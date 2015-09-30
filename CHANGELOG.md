# ActiveUtils changelog

### Version 3.1.0 (Sept. 30, 2015)
- Use ActiveUtils::HTTPRequestError as base exception class
- Add proxy address and port configuration
- Add support for Sin Maarten

### Version 3.0.0 (Jan. 16, 2015)

- Fully decoupled from ActiveMerchant: no longer uses `ActiveMerchant::` as namespace, but uses `ActiveUtils::` instead.
- Bump ActiveSupport requirement to **>= 3.2**.
- The `Utils` module to generate unique identifiers has been removed. Use `SecureRandom` instead.
- Improved test setup.
