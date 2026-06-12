import net.http
import encoding.base64
import os

fn main() {
  resp := http.get("http://rosettacode.org/favicon.ico") or {println(err) exit(-1)}
  encoded := base64.encode_str(resp.body)
  println(encoded)
  // Check if can decode and save
  decoded := base64.decode_str(encoded)
  os.write_file("./favicon.ico", decoded) or {println("File not created or written to!")}
}
