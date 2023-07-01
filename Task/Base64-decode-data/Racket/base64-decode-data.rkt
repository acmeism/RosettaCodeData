#lang racket
(require net/url net/base64)

;; decode a string
(displayln (base64-decode #"VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="))

;; (encode and) decode the favicon
(displayln (base64-decode (base64-encode (call/input-url (string->url "https://rosettacode.org/favicon.ico")
                                              get-pure-port port->bytes))))
