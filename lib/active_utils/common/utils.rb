require 'securerandom'

module ActiveMerchant #:nodoc:
  module Utils #:nodoc:
    def generate_unique_id
      SecureRandom.hex(16)
    end

    module_function :generate_unique_id

    def deprecated(message)
      warn(Kernel.caller[1] + message)
    end
  end
end
