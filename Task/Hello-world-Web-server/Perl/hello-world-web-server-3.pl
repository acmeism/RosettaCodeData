while (++(our $vn)) {
  open NC, "|-", qw(nc -l -p 8080 -q 1);
  print NC "HTTP/1.0 200 OK\xd\xa",
      "Content-type: text/plain; charset=utf-8\xd\xa\xd\xa",
      "Goodbye, World! (hello, visitor No. $vn!)\xd\xa";
}
