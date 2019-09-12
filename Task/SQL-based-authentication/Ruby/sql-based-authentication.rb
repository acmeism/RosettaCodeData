require 'mysql2'
require 'securerandom'
require 'digest'

def connect_db(host, port = nil, username, password, db)
  Mysql2::Client.new(
    host: host,
    port: port,
    username: username,
    password: password,
    database: db
  )
end

def create_user(client, username, password)
  salt = SecureRandom.random_bytes(16)
  password_md5 = Digest::MD5.hexdigest(salt + password)

  statement = client.prepare('INSERT INTO users (username, pass_salt, pass_md5) VALUES (?, ?, ?)')
  statement.execute(username, salt, password_md5)
  statement.last_id
end

def authenticate_user(client, username, password)
  user_record = client.prepare("SELECT SELECT pass_salt, pass_md5 FROM users WHERE username = '#{client.escape(username)}'").first
  return false unless user_record

  password_md5 = Digest::MD5.hexdigest(user_record['pass_salt'] + password)
  password_md5 == user_record['pass_md5']
end
