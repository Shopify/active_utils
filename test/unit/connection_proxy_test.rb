require 'test_helper'
require 'unit/connection_test'

class ConnectionProxyTest < ConnectionTest
  def setup
    @ok = stub(:code => 200, :message => 'OK', :body => 'success')

    ActiveMerchant::Connection.proxy = 'https://proxyserver.com:1234'
    @endpoint   = 'https://example.com/tx.php'
    @connection = ActiveMerchant::Connection.new(@endpoint)
  end
end
