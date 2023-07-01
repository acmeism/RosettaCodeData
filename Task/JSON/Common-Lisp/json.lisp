(ql:quickload '("cl-json"))

(json:encode-json
 '#( ((foo . (1 2 3)) (bar . t) (baz . #\!))
    "quux" 4/17 4.25))

(print (with-input-from-string
	   (s "{\"foo\": [1, 2, 3], \"bar\": true, \"baz\": \"!\"}")
	 (json:decode-json s)))
