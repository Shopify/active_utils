#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'bundler'
Bundler.setup

require 'test/unit'
require 'active_utils'
require 'mocha/setup'

include ActiveMerchant

require 'active_support/version.rb'
if ActiveSupport::VERSION::MAJOR < 3
  require 'active_support/core_ext/object/blank.rb'
end