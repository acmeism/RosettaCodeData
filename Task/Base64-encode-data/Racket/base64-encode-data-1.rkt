#lang racket
(require net/url net/base64)
(base64-encode (call/input-url (string->url "http://rosettacode.org/favicon.ico")
                               get-pure-port port->bytes))
