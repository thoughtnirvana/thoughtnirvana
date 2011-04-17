require 'bundler/setup'
require 'sinatra/base'
require 'slim'
require 'coffee-script'
require 'sass'

class App < Sinatra::Base
  configure do
    enable :dump_errors
    enable :logging
  end

  configure :production do
    set :clean_trace, true
  end

  def send_static_asset(sender, *args)
    #expires 15552000, :public, :must_revalidate
    sender.call *args 
  end

  configure :development do
    get %r(/css/ (.+?) \. (.*?\.)? css)x do |f, v| 
      send_static_asset method(:sass), :"sass/#{f}"
    end

    get %r(/js/ (.+?) \. (.*?\.)? js)x do |f, v|
      send_static_asset method(:coffee), :"coffee/#{f}"
    end
  end
end

require_relative 'helpers/init'
require_relative 'controllers/init'
