require 'pg'

if ENV["RACK_ENV"] == "music_4um"
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
    username VARCHAR(255),
    email VARCHAR(255),
    location VARCHAR(255),
    img_url VARCHAR NOT NULL
  )"
)

conn.exec("CREATE TABLE threads(
  id SERIAL PRIMARY KEY,
  topic VARCHAR(255),
  user_id INTEGER REFERENCES users(id)
  )"
)

conn.exec("CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  thread_id INTEGER REFERENCES threads(id),
  user_id INTEGER REFERENCES users(id)
  )"
)

# conn.exec("INSERT INTO user (username, img, location) VALUES (
#     'Bryan',
#     'bryan.mytko@generalassemb.ly',
#     'This is a test message from the seeded data'
#   )"
# )
