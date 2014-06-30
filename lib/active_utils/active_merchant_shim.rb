module ActiveUtils
  MOVED_NAMESPACE_MESSAGE = "All active_utils models have been moved to the ActiveUtils namespace, but you have referenced one from the ActiveMerchant namespace. Doing so will be deprecated in active_utils 3.x."
  MOVED_CONSTANTS = %w(
    NetworkConnectionRetries
    Connection
    Country
    CountryCode
    InvalidCountryCodeError
    CountryCodeFormatError
    ActiveUtilsError
    ConnectionError
    RetriableConnectionError
    ResponseError
    ClientCertificateError
    InvalidResponseError
    PostData
    PostsData
    RequiresParameters
    Utils
    Validateable
    CurrencyCode
    InvalidCurrencyCodeError
  )
end

module ActiveMerchant
  def self.shim(mod)
    if mod.methods(false).include?(:const_missing)
      raise ArgumentError, "ActiveMerchant compatibility cannot be used because #{mod} already defines const_missing."
    end

    mod.class_eval %(
      def self.const_missing(name)
        if ActiveUtils::MOVED_CONSTANTS.include?(name.to_s)
          ActiveUtils::Utils.deprecated(ActiveUtils::MOVED_NAMESPACE_MESSAGE)
          ActiveUtils.const_get(name)
        else
          super
        end
      end
    )
  end

  def self.included(mod)
    shim(mod)
  end

  shim(self)
end
