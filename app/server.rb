# Requires the Gemfile
require 'bundler' ; Bundler.require

set :bind, '0.0.0.0'

# By default Sinatra will return the string as the response.
get '/hello-world' do
  "Hello World!"
end
