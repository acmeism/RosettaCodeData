using HTTP, MbedTLS

conf = MbedTLS.SSLConfig(true, log_secrets="/utl/secret_key_log.log")
resp = HTTP.get("https://httpbin.org/ip", sslconfig=conf)

println(resp)
