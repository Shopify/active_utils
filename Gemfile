source "http://rubygems.org"

gemspec

rails_version = ENV['RAILS_VERSION'] || 'default'

rails = case rails_version
when 'master'
  { :github => 'rails/rails'}
when "default"
  '~> 3.2.0'
else
  "~> #{rails_version}"
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'minitest'
  gem 'rubinius-developer_tools'
end

gem 'activesupport', rails
