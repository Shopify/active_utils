require 'active_utils'
require 'minitest/autorun'
require 'mocha/setup'

include ActiveUtils

# This makes sure that Minitest::Test exists when an older version of Minitest
# (i.e. 4.x) is required by ActiveSupport.
unless defined?(Minitest::Test)
  Minitest::Test = MiniTest::Unit::TestCase
end
