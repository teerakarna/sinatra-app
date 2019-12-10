# Requires the Gemfile
require 'bundler' ; Bundler.require

set :bind, '0.0.0.0'

# By default Sinatra will return this string as the response.
get '/' do
  "Hello World!"
end
