# ActiveUtils changelog

### Version 3.3.9 (September 28, 2017)
- Add remaining currencies to `ActiveUtils::CurrencyCode::ISO_CURRENCIES`
- Update bundler in `travis.yml`

### Version 3.3.8 (August 15, 2017)
- Add `BO` to `ActiveUtils::Country::COUNTRIES_THAT_DO_NOT_USE_POSTALCODES`

### Version 3.3.7 (June 26, 2017)
- Add `CVE` to `ActiveUtils::CurrencyCode::ISO_CURRENCIES`

### Version 3.3.6 (May 23, 2017)
- Add `South Sudan` country in `ActiveUtils::Country::COUNTRIES_THAT_DO_NOT_USE_POSTALCODES`

### Version 3.3.5 (May 18, 2017)
- Add `South Sudan` and `Antarctica` countries in `ActiveUtils::Country::COUNTRIES`

### Version 3.3.4 (Apr. 18, 2017)
- Add `Ghana` country in `ActiveUtils::Country::COUNTRIES_THAT_DO_NOT_USE_POSTALCODES`

### Version 3.3.3 (Apr. 7, 2017)
- Add the `Aland Islands` country in `ActiveUtils::Country::COUNTRIES`

### Version 3.3.2 (Mar. 28, 2017)
- Changed country name of "Libyan Arab Jamahiriya" to Libya, as per country name change in 2011.

### Version 3.3.1 (Mar. 28, 2017)
- Bump ActiveSupport requirement to **< 5.2.0**.

### Version 3.3.0 (Mar. 10, 2017)
- Reduced default PostsData open_timeout from 60 seconds to 2, and read_timeout from 60 seconds to 10. Subclasses can and should override those values.
- Replace Kosovo's alpha 2 and alpha 3 ISO codes from `KV` to `XK` and from `KSV` to `XKX`.

### Version 3.2.5 (Feb. 2, 2017)
- Add the `TMT` currency in the supported currency codes

### Version 3.2.4 (Dec. 16, 2016)
- Add the `Bonaire` country in `ActiveUtils::Country::COUNTRIES`

### Version 3.2.3 (Nov. 21, 2016)
- Add the `:delay` option in `ActiveUtils::NetworkConnectionRetries`

### Version 3.2.2 (Jul. 4, 2016)
- Add tests for Rails 5 support

### Version 3.2.1 (Oct. 26, 2015)
- Add the malaysian currency code "RM" in `ActiveUtils::CurrencyCode`

### Version 3.2.0 (Oct. 13, 2015)
- Add #uses_postal_codes? to `ActiveUtils::Country`

### Version 3.1.0 (Sept. 30, 2015)
- Use ActiveUtils::HTTPRequestError as base exception class
- Add proxy address and port configuration
- Add support for Sin Maarten

### Version 3.0.0 (Jan. 16, 2015)

- Fully decoupled from ActiveMerchant: no longer uses `ActiveMerchant::` as namespace, but uses `ActiveUtils::` instead.
- Bump ActiveSupport requirement to **>= 3.2**.
- The `Utils` module to generate unique identifiers has been removed. Use `SecureRandom` instead.
- Improved test setup.
