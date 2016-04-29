module Sinatra
  class Server < Sinatra::Base
    # db = PG.connect(dbname: 'music_4um')

    get "/" do
      erb :index
    end

    # get '/user' do
    #   @users = db.exec("SELECT * FROM users")
    #   erb :users
    # end

    get '/users/:id' do
      @id = params[:id]
      @users = db.exec("SELECT * FROM users WHERE id=#{@id}").first
      erb :user
    end

    get '/threads' do
      @threads = db.exec("SELECT * FROM threads")
      erb :threads
    end

    get '/threads/:id' do
      @threadID = params[:id]
      @threads = db.exect("SELECT * FROM threads WHERE id={@threadID}")
      @commentsInThread = db.exec("SELECT * FROM comments WHERE id=#{@threadID}")
      erb :thread
    end

    def conn
        if ENV["RACK_ENV"] == "production"
            PG.connect(
                dbname: ENV["POSTGRES_DB"],
                host: ENV["POSTGRES_HOST"],
                password: ENV["POSTGRES_PASS"],
                user: ENV["POSTGRES_USER"]
             )
        else
            PG.connect(dbname: "portfolio")
        end
      end

  end
end
