data = File.read!("favicon.ico")
encoded = :base64.encode(data)
IO.puts encoded
