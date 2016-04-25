require 'rake'

Gem::Specification.new do |s|
  s.name = 'urbanairship-ruby'
  s.license = 'BSD'
  s.version = '1.0.1'
  s.date = '2015-07-14'
  s.summary = 'A Ruby wrapper for the Urban Airship API'
  s.description = 'urbanairship-ruby is a Ruby library for interacting with the UrbanAirship (http://urbanairship.com) API. We support latest API v3 and Ruby 1.8.6 or later.'
  s.homepage = 'http://github.com/huyha85/urbanairship-ruby'
  s.authors = ['HuyHa', 'ThaiXuan']
  s.email = ['hhuy424@gmail.com']
  s.files = FileList['README.markdown', 'Rakefile', 'lib/**/*.rb'].to_a
  s.test_files = FileList['spec/**/*.rb'].to_a

  s.add_dependency 'json'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'

  s.required_ruby_version = '>= 1.8.6'
end
