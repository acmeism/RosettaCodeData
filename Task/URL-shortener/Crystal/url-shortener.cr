require "kemal"

CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars
entries = Hash(String, String).new

post "/" do |env|
  short = Random::Secure.random_bytes(8).map{|b| CHARS[b % CHARS.size]}.join
  entries[short] = env.params.json["long"].as(String)
  "http://localhost:3000/#{short}"
end

get "/:short" do |env|
  if long = entries[env.params.url["short"]]?
    env.redirect long
  else
    env.response.status_code = 404
  end
end

error 404 do
  "invalid short url"
end

Kemal.run
