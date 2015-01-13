# ActiveUtils [![Build Status](https://travis-ci.org/Shopify/active_utils.svg?branch=master)](https://travis-ci.org/Shopify/active_utils)

ActiveUtils extracts commonly used modules and classes extracted from [Active Merchant](http://github.com/Shopify/active_merchant), to be used for other integration libraries.

### Included modules and classes

* `Connection` - base class for making HTTP requests
* `Country` - find countries mapped by name, country codes, and numeric values
* `Error` - common error classes used throughout the Active projects
* `PostData` - helper class for managing required fields that are to be POST-ed
* `PostsData` - making SSL HTTP requests
* `RequiresParameters` - helper method to ensure the required parameters are passed in
* `Validateable` - module used for making models validateable
* `NetworkConnectionRetries` - module for retrying network connections when connection errors occur
* `CurrencyCode` - ensure currency codes are ISO, and convert colloquial codes to ISO.

### Libraries that depend on ActiveUtils

- [ActiveShipping](https://github.com/Shopify/active_shipping)
- [ActiveFulfillment](https://github.com/Shopify/active_fulfillment)
- [OffsitePayments](https://github.com/Shopify/offsite_payments)

### ActiveMerchant link

While most of the code in this library was extracted from ActiveMerchant, ActiveMerchant itself doesn't use this library anymore. For PCI compliance reasons, we aim to keep the number of dependencies of ActiveMerchant as low as possible. For this reason, many of these classes and modules are mirrored in ActiveMerchant (e.g. `ActiveUtils::Connection` vs. `ActiveMerchant::Connection`. When making changes to this library, you may want to mirror those changes in ActiveMerchant.

### Misc

- This project is MIT licensed.
- Contributions are gladly accepted! See `CONTRIBUTING.md` for more information.
