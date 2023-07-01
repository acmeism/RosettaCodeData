while (++(our $vn)) {
  open NC, "|-", qw(nc -l -p 8080 -q 1);
  print NC "HTTP/1.0 200 OK\xd\xa",
      "Content-type: text/plain; charset=utf-8\x0d\x0a\x0d\x0a",
      "Goodbye, World! (hello, visitor No. $vn!)\x0d\x0a";
}
