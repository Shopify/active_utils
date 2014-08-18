require 'securerandom'

module ActiveUtils #:nodoc:
  module Utils #:nodoc:
    def generate_unique_id
      SecureRandom.hex(16)
    end
    module_function :generate_unique_id

    def deprecated(message)
      warning = Kernel.caller[1] + message
      if respond_to?(:logger) && logger.present?
        logger.warn(warning)
      else
        warn(warning)
      end
    end
    module_function :deprecated
  end
end
