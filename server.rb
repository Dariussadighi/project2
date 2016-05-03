module Sinatra
  class Server < Sinatra::Base
    set :method_override, true
    enable :sessions

    def current_user
      @current_user ||= conn.exec("SELECT * FROM users WHERE id=#{session[:user_id]}").first
    end

    def logged_in?
      current_user
    end

    get "/" do
      erb :index
    end

    get "/about" do
      erb :about
    end

    post "/signup" do
      @email = params[:email]
      @password = BCrypt::Password::create(params[:password])

      conn.exec_params(
        "INSERT INTO users (email, password) VALUES ($1, $2)",
        [@email, @password]
      )
      redirect to ("/")
    end

    get "/contact" do
      erb :contact
    end

    post "/login" do
      @email = params[:email]
      @password = params[:password]

      @user = conn.exec_params(
        "SELECT * FROM users WHERE email=$1 LIMIT 1",
        [@email]
      ).first
      redirect to ("/threads")

      if @user && BCrypt::Password::new(@user["password"]) == params[:password]
        "You have successfully logged in"
        session[:user_id] = @user["id"]
      else
        "Incorrect email or password!"
      end
    end

    get '/users/:id' do
      @id = params[:id]
      @users = conn.exec_params("SELECT * FROM users WHERE id=$1",[@id])
      erb :user
    end

    get '/threads' do
      @threads = conn.exec("SELECT * FROM threads")
      erb :threads
    end

    post '/threads' do
      @topic = params[:topic]
      conn.exec_params("INSERT INTO threads (topic) VALUES ($1)", [@topic])
      redirect to('/threads')
    end

    get '/threads/:id' do
      @id = params[:id].to_i
      @threads = conn.exec("SELECT * FROM threads WHERE id=$1",[@id])
      @thread_id = @threads.to_a[0]['id'].to_i
      @comments = conn.exec("SELECT * FROM comments WHERE thread_id=$1",[@id])
      erb :thread
    end

    post '/comments' do
      @body = params[:body]
      @thread_id = params[:thread_id].to_i
      conn.exec_params("INSERT INTO comments (body, thread_id) VALUES ($1, $2)", [@body, @thread_id])
      redirect to("/threads/#{@thread_id}")
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
            PG.connect(dbname: "music_4um")
        end
      end

  end
end
