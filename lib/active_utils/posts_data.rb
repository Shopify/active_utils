module ActiveUtils #:nodoc:
  module PostsData  #:nodoc:

    def self.included(base)
      base.class_attribute :ssl_strict
      base.ssl_strict = true

      base.class_attribute :ssl_version
      base.ssl_version = nil

      base.class_attribute :retry_safe
      base.retry_safe = false

      base.class_attribute :open_timeout
      base.open_timeout = 2

      base.class_attribute :read_timeout
      base.read_timeout = 10

      base.class_attribute :max_retries
      base.max_retries = Connection::MAX_RETRIES

      base.class_attribute :logger
      base.class_attribute :wiredump_device

      base.class_attribute :proxy_address
      base.proxy_address = Connection::PROXY_ADDRESS

      base.class_attribute :proxy_port

      base.class_attribute :persistent_connections
      base.persistent_connections = false

      base.class_attribute :pool_size
      base.pool_size = 100

      base.class_attribute :pool_idle_timeout
      base.pool_idle_timeout = 60

      base.class_attribute :pool_keep_alive
      base.pool_keep_alive = 60

      base.class_attribute :pool_max_requests
      base.pool_max_requests = 100

      base.define_singleton_method(:connection_pool) do
        @connection_pool ||= begin
          require 'net/http/persistent'
          pool = Net::HTTP::Persistent.new(name: name, pool_size: pool_size)
          pool.idle_timeout = pool_idle_timeout
          pool.keep_alive = pool_keep_alive
          pool.max_requests = pool_max_requests
          pool
        end
      end

      base.define_singleton_method(:clear_connection_pool!) do
        @connection_pool&.shutdown
        @connection_pool = nil
      end
    end

    def ssl_get(endpoint, headers={})
      ssl_request(:get, endpoint, nil, headers)
    end

    def ssl_post(endpoint, data, headers = {})
      ssl_request(:post, endpoint, data, headers)
    end

    def ssl_request(method, endpoint, data, headers)
      handle_response(raw_ssl_request(method, endpoint, data, headers))
    end

    def raw_ssl_request(method, endpoint, data, headers = {})
      logger.warn "#{self.class} using ssl_strict=false, which is insecure" if logger unless ssl_strict
      logger.warn "#{self.class} posting to plaintext endpoint, which is insecure" if logger unless endpoint.to_s =~ /^https:/

      if persistent_connections
        persistent_ssl_request(method, endpoint, data, headers)
      else
        connection = new_connection(endpoint)
        connection.open_timeout = open_timeout
        connection.read_timeout = read_timeout
        connection.retry_safe   = retry_safe
        connection.verify_peer  = ssl_strict
        connection.ssl_version  = ssl_version
        connection.logger       = logger
        connection.max_retries  = max_retries
        connection.tag          = self.class.name
        connection.wiredump_device = wiredump_device

        connection.pem          = @options[:pem] if @options
        connection.pem_password = @options[:pem_password] if @options

        connection.ignore_http_status = @options[:ignore_http_status] if @options

        connection.proxy_address = proxy_address
        connection.proxy_port = proxy_port

        connection.request(method, data, headers)
      end
    end

    private

    def new_connection(endpoint)
      Connection.new(endpoint)
    end

    def persistent_ssl_request(method, endpoint, data, headers)
      pool = self.class.connection_pool
      uri = endpoint.is_a?(URI) ? endpoint : URI.parse(endpoint)

      pool.open_timeout = open_timeout
      pool.read_timeout = read_timeout

      req = case method
      when :get
        raise ArgumentError, "GET requests do not support a request body" if data
        Net::HTTP::Get.new(uri.request_uri, headers)
      when :post
        Net::HTTP::Post.new(uri.request_uri, Connection::RUBY_184_POST_HEADERS.merge(headers)).tap { |r| r.body = data }
      when :put
        Net::HTTP::Put.new(uri.request_uri, headers).tap { |r| r.body = data }
      when :patch
        Net::HTTP::Patch.new(uri.request_uri, headers).tap { |r| r.body = data }
      when :delete
        raise ArgumentError, "DELETE requests do not support a request body" if data
        Net::HTTP::Delete.new(uri.request_uri, headers)
      else
        raise ArgumentError, "Unsupported request method #{method.to_s.upcase}"
      end

      pool.request(uri, req)
    rescue *NetworkConnectionRetries::DEFAULT_CONNECTION_ERRORS.keys => e
      raise ActiveUtils::ConnectionError, NetworkConnectionRetries::DEFAULT_CONNECTION_ERRORS.fetch(
        (NetworkConnectionRetries::DEFAULT_CONNECTION_ERRORS.keys & e.class.ancestors).first,
        e.message
      )
    rescue *NetworkConnectionRetries::DEFAULT_RETRY_ERRORS.keys => e
      raise ActiveUtils::ConnectionError, NetworkConnectionRetries::DEFAULT_RETRY_ERRORS.fetch(
        (NetworkConnectionRetries::DEFAULT_RETRY_ERRORS.keys & e.class.ancestors).first,
        e.message
      )
    end

    def handle_response(response)
      case response.code.to_i
      when 200...300
        response.body
      else
        raise ResponseError.new(response)
      end
    end

  end
end
