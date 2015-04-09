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
  end

  def test_logger_no_warning_if_ssl_strict_enabled
    @poster.logger = stub()
    @poster.logger.stubs(:warn).never
    Connection.any_instance.stubs(:request)

    SSLPoster.ssl_strict = true
    @poster.raw_ssl_request(:post, "https://shopify.com", "", {})
  end

  def test_set_proxy_address_and_port
    SSLPoster.proxy_address = 'http://proxy.example.com'
    SSLPoster.proxy_port = '8888'
    assert_equal @poster.proxy_address, 'http://proxy.example.com'
    assert_equal @poster.proxy_port, '8888'
  end
end
