module ActiveUtils #:nodoc:
  class ActiveUtilsError < StandardError #:nodoc:
  end

  class ConnectionError < ActiveUtilsError # :nodoc:
  end

  class RetriableConnectionError < ConnectionError # :nodoc:
  end

  class ResponseError < ActiveUtilsError # :nodoc:
    attr_reader :response

    def initialize(response, message = nil)
      @response = response
      @message  = message
    end

    def to_s
      "Failed with #{response.code} #{response.message if response.respond_to?(:message)}"
    end
  end

  class ClientCertificateError < ActiveUtilsError # :nodoc
  end

  class InvalidResponseError < ActiveUtilsError # :nodoc
  end
end
