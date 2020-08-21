require 'test_helper'

class CountryTest < Minitest::Test
  def test_country_from_hash
    country = Country.new(:name => 'Canada', :alpha2 => 'CA', :alpha3 => 'CAN', :numeric => '124')
    assert_equal 'CA', country.code(:alpha2).value
    assert_equal 'CAN', country.code(:alpha3).value
    assert_equal '124', country.code(:numeric).value
    assert_equal 'Canada', country.to_s
  end

  def test_country_for_alpha2_code
    country = Country.find('CA')
    assert_equal 'CA', country.code(:alpha2).value
    assert_equal 'CAN', country.code(:alpha3).value
    assert_equal '124', country.code(:numeric).value
    assert_equal 'Canada', country.to_s
  end

  def test_country_for_alpha3_code
    country = Country.find('CAN')
    assert_equal 'Canada', country.to_s
  end

  def test_country_for_numeric_code
    country = Country.find('124')
    assert_equal 'Canada', country.to_s
  end

  def test_find_country_by_name
    country = Country.find('Canada')
    assert_equal 'Canada', country.to_s
  end

  def test_find_unknown_country_name
    assert_raises(InvalidCountryCodeError) do
      Country.find('Asskickistan')
    end
  end

  def test_find_australia
    country = Country.find('AU')
    assert_equal 'AU', country.code(:alpha2).value

    country = Country.find('Australia')
    assert_equal 'AU', country.code(:alpha2).value
  end

  def test_find_united_kingdom
    country = Country.find('GB')
    assert_equal 'GB', country.code(:alpha2).value

    country = Country.find('United Kingdom')
    assert_equal 'GB', country.code(:alpha2).value
  end

  def test_raise_on_nil_name
    assert_raises(InvalidCountryCodeError) do
      Country.find(nil)
    end
  end

  def test_country_names_are_alphabetized
    country_names = Country::COUNTRIES.map { | each | each[:name] }
    assert_equal(country_names.sort, country_names)
  end

  def test_countries_that_do_not_use_postalcodes_are_unique
    country_codes = Country::COUNTRIES_THAT_DO_NOT_USE_POSTALCODES
    assert_equal(country_codes.uniq.length, country_codes.length)
  end

  def test_change_to_countries_that_do_not_use_postalcodes_is_intentional
    country_codes = Country::COUNTRIES_THAT_DO_NOT_USE_POSTALCODES
    assert_equal(country_codes.length, 31)
  end

  def test_canada_uses_postal_codes
    canada = Country.find('Canada')
    assert canada.uses_postal_codes?
  end

  def test_qatar_does_not_use_postal_codes
    qatar = Country.find('Qatar')
    refute qatar.uses_postal_codes?
  end
end
