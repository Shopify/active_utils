module ActiveUtils
  class InvalidCurrencyCodeError < StandardError
  end

  class CurrencyCode
    ISO_CURRENCIES = [
      "AED", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD",
      "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYR", "BZD", "CAD", "CHF", "CLP", "CNY", "COP", "CRC",
      "CZK", "DKK", "DOP", "DZD", "EGP", "ETB", "EUR", "FJD", "GBP", "GEL", "GHS", "GMD", "GTQ", "GYD",
      "HKD", "HNL", "HRK", "HUF", "IDR", "ILS", "INR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS",
      "KHR", "KRW", "KWD", "KYD", "KZT", "LBP", "LKR", "LTL", "LVL", "MAD", "MDL", "MGA", "MKD", "MMK",
      "MNT", "MOP", "MUR", "MVR", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR",
      "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SCR", "SEK",
      "SGD", "STD", "SYP", "THB", "TND", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "VEF",
      "VND", "VUV", "WST", "XAF", "XCD", "XOF", "XPF", "ZAR", "ZMW"
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
