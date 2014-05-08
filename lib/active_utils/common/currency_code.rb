module ActiveMerchant
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
      "ARN" => "ARS",
      "AZM" => "AZN",
      "CHP" => "CLP",
      "DHS" => "AED",
      "ECD" => "XCD",
      "GHC" => "GHS",
      "JAD" => "JMD",
      "JYE" => "JPY",
      "KUD" => "KWD",
      "MZM" => "MZN",
      "NTD" => "TWD",
      "NMP" => "MXN",
      "RDD" => "DOP",
      "RMB" => "CNY",
      "SFR" => "CHF",
      "SID" => "SGD",
      "UKL" => "GBP",
      "WON" => "KRW"
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
