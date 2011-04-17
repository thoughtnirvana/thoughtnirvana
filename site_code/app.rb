require 'bundler/setup'
require 'sinatra/base'
require 'slim'
require 'coffee-script'
require 'sass'

class App < Sinatra::Base
  STATIC_DIR = File.join(File.dirname(__FILE__), 'public')

  configure do
    enable :dump_errors
    enable :logging
    set :public, STATIC_DIR
  end

  def send_static_asset(sender, *args)
    expires 15552000, :public
    sender.call *args 
  end

  configure :development do
    get %r(/css/ (.+?) \. (.+?\.)? css)x do |f, v| 
      send_static_asset method(:sass), :"sass/#{f}"
    end

    get %r(/js/ (.+?) \. (.+?\.)? js)x do |f, v|
      send_static_asset method(:coffee), :"coffee/#{f}"
    end
  end

  configure :production do
    get %r(/css/ (.+?) \. (.+?\.)? css)x do |f, v| 
      expires 15552000, :public
      send_file File.join(STATIC_DIR, "css", "#{f}.css" )
    end

    get %r(/js/ (.+?) \. (.+?\.)? js)x do |f, v| 
      expires 15552000, :public
      send_file File.join(STATIC_DIR, "js", "#{f}.js" )
    end

    get %r(/img/ (.+?) (\..+?)? (\..+)$)x do |f, v, ext| 
      expires 15552000, :public
      send_file File.join(STATIC_DIR, "img", "#{f}#{ext}" )
    end
  end

end

require_relative 'helpers/init'
require_relative 'controllers/init'

App.run! if __FILE__ == $0
