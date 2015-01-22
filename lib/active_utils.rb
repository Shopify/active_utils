require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/conversions'
require 'active_support/core_ext/class/attribute'

require 'active_utils/error'
require 'active_utils/version'

module ActiveUtils
  autoload :NetworkConnectionRetries,  'active_utils/network_connection_retries'
  autoload :Connection,                'active_utils/connection'
  autoload :Country,                   'active_utils/country'
  autoload :CountryCode,               'active_utils/country'
  autoload :InvalidCountryCodeError,   'active_utils/country'
  autoload :CountryCodeFormatError,    'active_utils/country'
  autoload :PostData,                  'active_utils/post_data'
  autoload :PostsData,                 'active_utils/posts_data'
  autoload :RequiresParameters,        'active_utils/requires_parameters'
  autoload :Validateable,              'active_utils/validateable'
  autoload :CurrencyCode,              'active_utils/currency_code'
  autoload :InvalidCurrencyCodeError,  'active_utils/currency_code'
end
