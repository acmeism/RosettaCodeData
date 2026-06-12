import base64
import httpclient

var client = newHttpClient()
let content = client.getContent("http://rosettacode.org/favicon.ico")
let encoded = encode(content)

if encoded.len <= 64:
  echo encoded
else:
  echo encoded[0..31] & "..." & encoded[^32..^1]
