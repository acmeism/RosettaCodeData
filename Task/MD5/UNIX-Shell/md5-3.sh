echo -n "The quick brown fox jumped over the lazy dog's back" |
  openssl md5 | sed 's/.*= //'
