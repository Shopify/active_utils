require 'test_helper'
require 'active_support/core_ext/class'

class PostsDataTest < Minitest::Test
  class SSLPoster
    include PostsData

    attr_accessor :logger
  end

  def setup
    @poster = SSLPoster.new
  end

  def test_ssl_request_retried_three_times_by_default
    requester = stubs(:requester)
    requester.expects(:post).raises(Errno::ECONNREFUSED).times(3)
    Connection.any_instance.stubs(:http => requester)

    assert_raises ActiveUtils::ConnectionError do
      @poster.raw_ssl_request(:post, "https://shopify.com", "", {})
    end
  end

  def test_ssl_request_never_retried_if_max_retries_set
    SSLPoster.max_retries = 1
    requester = stubs(:requester)
    requester.expects(:post).raises(Errno::ECONNREFUSED).times(1)
    Connection.any_instance.stubs(:http => requester)

    assert_raises ActiveUtils::ConnectionError do
      @poster.raw_ssl_request(:post, "https://shopify.com", "", {})
    end
  ensure
    SSLPoster.max_retries = ActiveUtils::Connection::MAX_RETRIES
  end

  def test_logger_warns_if_ssl_strict_disabled
    @poster.logger = stub()
    @poster.logger.expects(:warn).with("PostsDataTest::SSLPoster using ssl_strict=false, which is insecure")

    Connection.any_instance.stubs(:request)

    SSLPoster.ssl_strict = false
    @poster.raw_ssl_request(:post, "https://shopify.com", "", {})
  ensure
    SSLPoster.ssl_strict = true
  end

  def test_logger_warns_can_handle_non_string_endpoints
    @poster.logger = stub()
    @poster.logger.expects(:warn).with("PostsDataTest::SSLPoster posting to plaintext endpoint, which is insecure")

    Connection.any_instance.stubs(:request)

    @poster.raw_ssl_request(:post, URI("http://shopify.com"), "", {})
  end

  def test_logger_no_warning_if_ssl_strict_enabled
    @poster.logger = stub()
    @poster.logger.stubs(:warn).never
    Connection.any_instance.stubs(:request)

    SSLPoster.ssl_strict = true
    @poster.raw_ssl_request(:post, "https://shopify.com", "", {})
  end

  def test_set_proxy_address_and_port
    original_proxy_address = SSLPoster.proxy_address
    original_proxy_port = SSLPoster.proxy_port
    SSLPoster.proxy_address = 'http://proxy.example.com'
    SSLPoster.proxy_port = '8888'
    assert_equal @poster.proxy_address, 'http://proxy.example.com'
    assert_equal @poster.proxy_port, '8888'
  ensure
    SSLPoster.proxy_address = original_proxy_address
    SSLPoster.proxy_port = original_proxy_port
  end

  class HttpConnectionAbort < StandardError; end

  def test_respecting_environment_proxy_settings
    Net::HTTP.stubs(:new).with('example.com', 80, :ENV, nil).raises(PostsDataTest::HttpConnectionAbort)
    assert_raises(PostsDataTest::HttpConnectionAbort) do
      @poster.ssl_post('http://example.com', '')
    end
  end

  # --- Persistent connections tests ---

  def test_persistent_connections_default_off
    assert_equal false, SSLPoster.persistent_connections
  end

  def test_persistent_connections_uses_connection_when_off
    SSLPoster.persistent_connections = false
    Connection.any_instance.expects(:request).returns(stub(code: "200", body: "ok"))

    result = @poster.ssl_post("https://shopify.com", "data")
    assert_equal "ok", result
  ensure
    SSLPoster.persistent_connections = false
  end

  class PersistentPoster
    include PostsData

    self.persistent_connections = true
    self.pool_size = 5

    attr_accessor :logger
  end

  def teardown
    # Reset pool state without calling shutdown (which would fail on mocks)
    PersistentPoster.instance_variable_set(:@connection_pool, nil)
  end

  def test_persistent_connections_enabled_uses_pool
    pool = mock('pool')
    pool.expects(:open_timeout=).with(2)
    pool.expects(:read_timeout=).with(10)
    pool.expects(:request).with(
      instance_of(URI::HTTPS),
      instance_of(Net::HTTP::Post)
    ).returns(stub(code: "200", body: "pooled response"))

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    result = poster.ssl_post("https://example.com", "data")
    assert_equal "pooled response", result
  end

  def test_persistent_connection_pool_is_per_class
    pool_a = PersistentPoster.connection_pool
    pool_b = PersistentPoster.connection_pool
    assert_same pool_a, pool_b, "Same class should return the same pool instance"
  ensure
    PersistentPoster.connection_pool.shutdown
    PersistentPoster.instance_variable_set(:@connection_pool, nil)
  end

  def test_persistent_connection_per_request_timeout_override
    pool = mock('pool')
    pool.expects(:open_timeout=).with(5)
    pool.expects(:read_timeout=).with(3)
    pool.expects(:request).returns(stub(code: "200", body: "ok"))

    PersistentPoster.instance_variable_set(:@connection_pool, pool)
    PersistentPoster.open_timeout = 5
    PersistentPoster.read_timeout = 3

    poster = PersistentPoster.new
    poster.ssl_post("https://example.com", "data")
  ensure
    PersistentPoster.open_timeout = 2
    PersistentPoster.read_timeout = 10
  end

  def test_persistent_connection_raises_connection_error_on_timeout
    pool = mock('pool')
    pool.expects(:open_timeout=)
    pool.expects(:read_timeout=)
    pool.expects(:request).raises(Net::OpenTimeout, "execution expired")

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    error = assert_raises(ActiveUtils::ConnectionError) do
      poster.ssl_post("https://example.com", "data")
    end
    assert_match(/timed out/, error.message)
  end

  def test_persistent_connection_raises_connection_error_on_reset
    pool = mock('pool')
    pool.expects(:open_timeout=)
    pool.expects(:read_timeout=)
    pool.expects(:request).raises(Errno::ECONNRESET)

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    error = assert_raises(ActiveUtils::ConnectionError) do
      poster.ssl_post("https://example.com", "data")
    end
    assert_match(/reset/, error.message)
  end

  def test_persistent_connection_raises_connection_error_on_refused
    pool = mock('pool')
    pool.expects(:open_timeout=)
    pool.expects(:read_timeout=)
    pool.expects(:request).raises(Errno::ECONNREFUSED)

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    assert_raises(ActiveUtils::ConnectionError) do
      poster.ssl_post("https://example.com", "data")
    end
  end

  def test_persistent_connection_raises_response_error_on_non_2xx
    pool = mock('pool')
    pool.expects(:open_timeout=)
    pool.expects(:read_timeout=)
    pool.expects(:request).returns(stub(code: "422", body: "bad", message: "Unprocessable Entity"))

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    error = assert_raises(ActiveUtils::ResponseError) do
      poster.ssl_post("https://example.com", "data")
    end
    assert_equal "422", error.response.code
  end

  def test_persistent_connection_ssl_get
    pool = mock('pool')
    pool.expects(:open_timeout=)
    pool.expects(:read_timeout=)
    pool.expects(:request).with(
      instance_of(URI::HTTPS),
      instance_of(Net::HTTP::Get)
    ).returns(stub(code: "200", body: "get response"))

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    result = poster.ssl_get("https://example.com/path")
    assert_equal "get response", result
  end

  def test_persistent_connection_clear_pool
    pool = PersistentPoster.connection_pool
    refute_nil pool
    PersistentPoster.clear_connection_pool!
    assert_nil PersistentPoster.instance_variable_get(:@connection_pool)
  end

  def test_persistent_connection_post_includes_content_type_header
    pool = mock('pool')
    pool.expects(:open_timeout=)
    pool.expects(:read_timeout=)
    pool.expects(:request).with(
      instance_of(URI::HTTPS),
      instance_of(Net::HTTP::Post)
    ) do |_uri, req|
      assert_equal "application/x-www-form-urlencoded", req["Content-Type"]
      true
    end.returns(stub(code: "200", body: "ok"))

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    poster.ssl_post("https://example.com", "data")
  end

  def test_persistent_connection_merges_custom_headers
    pool = mock('pool')
    pool.expects(:open_timeout=)
    pool.expects(:read_timeout=)
    pool.expects(:request).with(
      instance_of(URI::HTTPS),
      instance_of(Net::HTTP::Post)
    ) do |_uri, req|
      assert_equal "application/json", req["Content-Type"]
      assert_equal "abc123", req["X-Custom"]
      true
    end.returns(stub(code: "200", body: "ok"))

    PersistentPoster.instance_variable_set(:@connection_pool, pool)

    poster = PersistentPoster.new
    poster.ssl_post("https://example.com", "data", { "Content-Type" => "application/json", "X-Custom" => "abc123" })
  end

  def test_pool_config_defaults
    assert_equal 100, SSLPoster.pool_size
    assert_equal 60, SSLPoster.pool_idle_timeout
    assert_equal 60, SSLPoster.pool_keep_alive
    assert_equal 100, SSLPoster.pool_max_requests
  end
end
