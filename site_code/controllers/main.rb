class App < Sinatra::Base
    get "/" do
        slim :'main/main'
    end
end
