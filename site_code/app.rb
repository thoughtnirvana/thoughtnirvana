require 'bundler/setup'
require 'sinatra/base'
require 'slim'

class App < Sinatra::Base

    configure do
        enable :sessions
        enable :dump_errors
    end

    configure :production do
        set :clean_trace, true
    end

    configure :development do
    end

    helpers do
        include Rack::Utils
        alias_method :h, :escape_html
    end

end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'controllers/init'
