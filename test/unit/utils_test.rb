require 'test_helper'

class UtilsTest < Minitest::Test
  def test_unique_id_should_be_32_chars_and_alphanumeric
    assert_match /^\w{32}$/, ActiveUtils::Utils.generate_unique_id
  end
end
