require 'test_helper'
require 'openssl'
require 'net/http'

class NetworkConnectionRetriesTest < Minitest::Test
  class MyNewError < StandardError
  end

  include NetworkConnectionRetries

  def setup
    @logger = stubs(:logger)
    @requester = stubs(:requester)
    @ok = stub(:code => 200, :message => 'OK', :body => 'success')
  end

  def test_unrecoverable_exception
    assert_raises(ActiveUtils::ConnectionError) do
      retry_exceptions do
        raise EOFError
      end
    end
  end

  def test_invalid_response_error
    assert_raises(ActiveUtils::InvalidResponseError) do
      retry_exceptions do
        raise Zlib::BufError
      end
    end
  end

  def test_unrecoverable_exception_logged_if_logger_provided
    @logger.expects(:info).once
    assert_raises(ActiveUtils::ConnectionError) do
      retry_exceptions :logger => @logger do
        raise EOFError
      end
    end
  end

  def test_failure_then_success_with_recoverable_exception
    @requester.expects(:post).times(2).raises(Errno::ECONNREFUSED).then.returns(@ok)

    retry_exceptions do
      @requester.post
    end
  end

  def test_failure_limit_reached
    @requester.expects(:post).times(ActiveUtils::NetworkConnectionRetries::DEFAULT_RETRIES).raises(Errno::ECONNREFUSED)

    assert_raises(ActiveUtils::ConnectionError) do
      retry_exceptions do
        @requester.post
      end
    end
  end

  def test_failure_limit_reached_logs_final_error
    @logger.expects(:info).times(3)
    @requester.expects(:post).times(ActiveUtils::NetworkConnectionRetries::DEFAULT_RETRIES).raises(Errno::ECONNREFUSED)

    assert_raises(ActiveUtils::ConnectionError) do
      retry_exceptions(:logger => @logger) do
        @requester.post
      end
    end
  end

  def test_failure_then_success_with_retry_safe_enabled
    @requester.expects(:post).times(2).raises(EOFError).then.returns(@ok)

    retry_exceptions :retry_safe => true do
      @requester.post
    end
  end

  def test_failure_then_success_logs_success
    @logger.expects(:info).with(regexp_matches(/dropped/))
    @logger.expects(:info).with(regexp_matches(/success/))
    @requester.expects(:post).times(2).raises(EOFError).then.returns(@ok)

    retry_exceptions(:logger => @logger, :retry_safe => true) do
      @requester.post
    end
  end

  def test_mixture_of_failures_with_retry_safe_enabled
    @requester.expects(:post).times(3).raises(Errno::ECONNRESET).
                                       raises(Errno::ECONNREFUSED).
                                       raises(EOFError)

    assert_raises(ActiveUtils::ConnectionError) do
      retry_exceptions :retry_safe => true do
        @requester.post
      end
    end
  end

  def test_failure_with_ssl_certificate
    @requester.expects(:post).raises(OpenSSL::X509::CertificateError)

    assert_raises(ActiveUtils::ClientCertificateError) do
      retry_exceptions do
        @requester.post
      end
    end
  end

  def test_failure_with_ssl_certificate_logs_error_if_logger_specified
    @logger.expects(:error).once
    @requester.expects(:post).raises(OpenSSL::X509::CertificateError)

    assert_raises(ActiveUtils::ClientCertificateError) do
      retry_exceptions :logger => @logger do
        @requester.post
      end
    end
  end

  def test_failure_with_additional_exceptions_specified
    @requester.expects(:post).raises(MyNewError)

    assert_raises(ActiveUtils::ConnectionError) do
      retry_exceptions :connection_exceptions => {MyNewError => "my message"} do
        @requester.post
      end
    end
  end

  def test_failure_without_additional_exceptions_specified
    @requester.expects(:post).raises(MyNewError)

    assert_raises(MyNewError) do
      retry_exceptions do
        @requester.post
      end
    end
  end
end
