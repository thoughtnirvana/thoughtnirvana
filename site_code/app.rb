require 'bundler/setup'
require 'sinatra/base'
require 'slim'
require 'coffee-script'
require 'sass'

class App < Sinatra::Base
  STATIC_DIR = File.join(File.dirname(__FILE__), 'public')
  VIEWS_DIR = File.join(File.dirname(__FILE__), 'views')
  EXPIRY_DURATION = 15552000

  configure do
    enable :dump_errors
    enable :logging
    set :public, STATIC_DIR
    set :views, VIEWS_DIR 
  end

  def send_static_asset(sender, *args)
    expires EXPIRY_DURATION, :public
    sender.call *args 
  end

  configure :development do
    # Generate css from sass.
    get %r(/css/ (.+?) \.css (;.+)$)x do |f, v| 
      send_static_asset method(:sass), :"sass/#{f}"
    end

    # Generate js from coffeescript.
    get %r(/js/ (.+?) \.js (;.+)$)x do |f, v|
      send_static_asset method(:coffee), :"coffee/#{f}"
    end
  end

  # Serve versioned image files if it falls back to the framework.
  get %r(/img/ (.+?)(;.+)$)x do |f, v| 
    send_static_asset method(:send_file),
      File.join(STATIC_DIR, "img", "#{f}" )
  end

  configure :production do
    # Serve from public directory. 
    # Statics should be served from webserver.
    # These rules are here basically for thin.
    get %r(/css/ (.+?\.css) (;.+)$)x do |f, v| 
      send_static_asset method(:send_file),
        File.join(STATIC_DIR, "css", "#{f}")
    end

    # Generate js from coffeescript.
    get %r(/js/ (.+?\.js)  (;.+)$)x do |f, v|
      send_static_asset method(:send_file),
        File.join(STATIC_DIR, "js", "#{f}")
    end
  end
end

require_relative 'helpers/init'
require_relative 'controllers/init'

App.run! if __FILE__ == $0
