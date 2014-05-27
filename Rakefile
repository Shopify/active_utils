require 'bundler/gem_tasks'
require 'bundler'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/unit/**/*_test.rb'
  t.ruby_opts << '-rubygems'
  t.libs << 'test'
  t.verbose = true
end

desc "Update the built-in CA root certificate file"
task :update_cert_file do
  require 'net/http'
  require 'uri'
  cert_uri = URI('http://curl.haxx.se/ca/cacert.pem')
  response = Net::HTTP.get_response(cert_uri)
  if response.code == '200'
    cert_path = File.expand_path('../lib/certs/cacert.pem', __FILE__)
    File.open(cert_path, 'w') { |cert_file| cert_file << response.body }
  else
    fail "Could not download certificate bundle from #{cert_uri}"
  end
end

task :default => "test"
