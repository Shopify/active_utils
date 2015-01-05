require 'active_utils'
require 'minitest/autorun'
require 'mocha/setup'

include ActiveUtils

def suppress_warnings
  original_verbosity, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = original_verbosity
end

class Minitest::Test
  def assert_deprecation_warning(message=nil)
    ActiveUtils::Utils.expects(:deprecated).with(message ? message : anything)
    yield
  end
end
