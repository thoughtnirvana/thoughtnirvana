class App < Sinatra::Base
  get "/" do
    expires 300, :public
    slim :'main/main'
  end
end
