require "test_helper"

class ActiveMerchantShimTest < Minitest::Test
  def test_should_get_a_deprecation_warning_if_accessing_via_active_merchant
    assert_deprecation_warning do
      suppress_warnings do
        ActiveMerchant::Utils
      end
    end
  end

  def test_should_be_able_to_access_constants
    suppress_warnings do
      assert_equal ActiveUtils::Utils, ActiveMerchant::Utils
    end
  end

  def test_should_be_able_access_after_include
    m = Module.new do
      include ActiveMerchant
    end

    suppress_warnings do
      assert_equal ActiveUtils::Utils, m::Utils
    end
  end

  def test_old_requires_work
    %w(
      active_utils/common/connection
      active_utils/common/country
      active_utils/common/currency_code
      active_utils/common/error
      active_utils/common/network_connection_retries
      active_utils/common/post_data
      active_utils/common/posts_data
      active_utils/common/requires_parameters
      active_utils/common/utils
      active_utils/common/validateable
      active_utils/common/version
    ).each do |path|
      assert_deprecation_warning do
        require path
      end
    end
  end
end
