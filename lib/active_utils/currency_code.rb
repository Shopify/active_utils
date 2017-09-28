module ActiveUtils
  class InvalidCurrencyCodeError < StandardError
  end

  class CurrencyCode
    ISO_CURRENCIES = [
      "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN",
      "BHD", "BIF", "BMD", "BND", "BOB", "BOV", "BRL", "BSD", "BTN", "BWP", "BYR", "BYN", "BZD", "CAD",
      "CDF", "CHE", "CHF", "CHW", "CLP", "CLF", "CNY", "COP", "COU", "CRC", "CUC", "CUP", "CVE", "CZK",
      "DKK", "DJF", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GHS", "GIP",
      "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IRR", "ISK",
      "IQD", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPY", "KRW", "KWD", "KYD", "KZT",
      "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT",
      "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MXV", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR",
      "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF",
      "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "SSP", "STD", "SVC", "SYP",
      "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "USN",
      "UYI", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XBA", "XBB", "XBC", "XBD",
      "XCD", "XDR", "XOF", "XPD", "XPF", "XPT", "XSU", "XTS", "XUA", "XXX", "YER", "ZAR", "ZMW", "ZWL"
    ]

    NON_ISO_TO_ISO = {
      "ARN" => "ARS", # Argentinian Pesos
      "AZM" => "AZN", # Azerbaijan New Manat
      "CHP" => "CLP", # Chilean Pesos
      "DHS" => "AED", # UAE Dirhams
      "ECD" => "XCD", # East Caribbean Dollars
      "GHC" => "GHS", # Ghana Cedi
      "JAD" => "JMD", # Jamaican Dollars
      "JYE" => "JPY", # Japanese Yen
      "KUD" => "KWD", # Kuwaiti Dinars
      "MZM" => "MZN", # Mozambique Metical
      "NMP" => "MXN", # Mexican Pesos
      "NTD" => "TWD", # New Taiwan Dollars / Taiwan New Dollars
      "RDD" => "DOP", # Dominican Pesos
      "RM" => "MYR",  # Malaysia Ringgit
      "RMB" => "CNY", # Chinese Renminbi
      "SFR" => "CHF", # Swiss Francs
      "SID" => "SGD", # Singapore Dollars
      "SOL" => "PES", # Peruvian Sol
      "UKL" => "GBP", # Great Britain Pounds
      "WON" => "KRW"  # South Korean Won
    }

    def self.standardize(code)
      code = code.upcase unless code.nil?

      return code if is_iso?(code)
      NON_ISO_TO_ISO[code] || raise(InvalidCurrencyCodeError, "#{code} is not an ISO currency, nor can it be converted to one.")
    end

    def self.is_iso?(code)
      ISO_CURRENCIES.include? code
    end
  end
end
