import "os" for Process

var certFile = "myCert.pem"
var keyFile  = "myKey.pem"
var url = "www.example.com"

Process.exec("curl", ["--cert", certFile, "--key", keyFile, url])
