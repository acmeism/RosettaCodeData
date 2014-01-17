(require 'hmac-md5)
(require 'hex-util)
(encode-hex-string
  (md5-binary "The quick brown fox jumped over the lazy dog's back"))
=>
"e38ca1d920c4b8b8d3946b2c72f01680"
