(use json)
(define object-example
  (with-input-from-string "{\"foo\": \"bar\", \"baz\": [1, 2, 3]}"
                          json-read))
(pp object-example)
; this prints #(("foo" . "bar") ("baz" 1 2 3))

(json-write #([foo . bar]
              [baz   1 2 3]
              [qux . #((rosetta . code))]))
; this writes the following:
; {"foo": "bar", "baz": [1, 2, 3], "qux": {"foo": "bar"}}
