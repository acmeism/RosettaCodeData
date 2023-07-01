; Character length
(print (string-length "Hello, wørld!"))
; ==> 13

; Byte (utf-8 encoded) length
(print (length (string->bytes "Hello, wørld!")))
; ==> 14
