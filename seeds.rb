require 'pg'

if ENV["RACK_ENV"] == "production"
    conn = PG.connect(
        dbname: ENV["POSTGRES_DB"],
        host: ENV["POSTGRES_HOST"],
        password: ENV["POSTGRES_PASS"],
        user: ENV["POSTGRES_USER"]
     )
else
    conn = PG.connect(dbname: "music_4um")
end


conn.exec("DROP TABLE IF EXISTS users CASCADE")
conn.exec("DROP TABLE IF EXISTS threads CASCADE")
conn.exec("DROP TABLE IF EXISTS comments")

conn.exec("CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL
  )"
)

conn.exec("CREATE TABLE threads(
  id SERIAL PRIMARY KEY,
  topic VARCHAR,
  user_id INTEGER REFERENCES users(id)
  )"
)

conn.exec("CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  body VARCHAR(255),
  thread_id INTEGER REFERENCES threads(id)
  )"
)
