require 'bundler/setup'
require 'sinatra/base'
require 'slim'
require 'coffee-script'
require 'sass'

class App < Sinatra::Base
    configure do
        enable :sessions
        enable :dump_errors
        enable :logging
    end

    configure :production do
        set :clean_trace, true
    end

    configure :development do
        get %r(/css/ (.+?) \. (.*?\.)? css)x do |f, v| 
            expires 15552000, :public
            last_modified Time.now() - 172800 
            sass :"sass/#{f}"
        end

        get %r(/js/ (.+?) \. (.*?\.)? js)x do |f, v|
            expires 15552000, :public
            last_modified Time.now() - 172800 
            coffee :"coffee/#{f}"
        end
    end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'controllers/init'
