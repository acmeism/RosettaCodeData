import httpclient, base64

const
  User = "admin"
  Password = "admin"

let headers = newHttpHeaders({"Authorization": "Basic " & base64.encode(User & ":" & Password)})
let client = newHttpClient(headers = headers)
echo client.getContent("https://httpbin.org/basic-auth/admin/admin")
