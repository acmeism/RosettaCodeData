import "os" for Process

var userPwd = "admin:admin"
var url = "https://httpbin.org/basic-auth/admin/admin"
Process.exec("curl", ["-u", userPwd, url])
