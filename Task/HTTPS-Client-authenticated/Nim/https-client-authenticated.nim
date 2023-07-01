import httpclient, net
var client = newHttpClient(sslContext = newContext(certFile = "mycert.pem"))
var r = client.get("https://www.example.com")
