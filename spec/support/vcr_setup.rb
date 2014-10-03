require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.filter_sensitive_data('YOUR_CTA_API_KEY') { ENV['CTA_API_KEY'] }
  c.ignore_localhost = true
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
