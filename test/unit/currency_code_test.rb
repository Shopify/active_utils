require 'test_helper'

class CurrencyCodeTest < Minitest::Test
  def test_is_iso_should_return_true_for_iso_currencies
    assert CurrencyCode.is_iso?('CAD')
    assert CurrencyCode.is_iso?('USD')
    assert CurrencyCode.is_iso?('TWD')
  end

  def test_is_iso_should_return_false_for_non_iso_currencies
    assert !CurrencyCode.is_iso?('NTD')
    assert !CurrencyCode.is_iso?('RMB')
  end

  def test_standardize_should_not_change_iso_currencies
    assert_equal 'CAD', CurrencyCode.standardize('CAD')
    assert_equal 'USD', CurrencyCode.standardize('usd')
    assert_equal 'TWD', CurrencyCode.standardize('TWD')
  end

  def test_standardize_should_convert_known_non_iso_to_iso
    assert_equal 'TWD', CurrencyCode.standardize('NTD')
    assert_equal 'CNY', CurrencyCode.standardize('rmb')
  end

  def test_standardize_should_raise_for_unknwon_currencies
    assert_raises CurrencyCode::InvalidCurrencyCodeError do
      CurrencyCode.standardize('Not Real')
    end
  end

  def test_nil_code_should_raise_InvalidCurrencyCodeError
    assert_raises CurrencyCode::InvalidCurrencyCodeError do
      CurrencyCode.standardize(nil)
    end
  end
end
