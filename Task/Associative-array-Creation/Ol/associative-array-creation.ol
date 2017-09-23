; empty associative array has two names
#empty
#()

; creating the new empty associative array
(define empty-map #empty)

; creating associative array with values
(define my-map (list->ff '(
   (1 . 100)
   (2 . 200)
   (7 . 777))))

; add new key-value pair to the existing associative array
(define my-new-map (put my-map 'the-key 'the-value))

; print our arrays
(print empty-map)
; ==> #()
(print my-map)
; ==> #((1 . 100) (2 . 200) (7 . 777))
(print my-new-map)
; ==> #((1 . 100) (2 . 200) (7 . 777) (the-key . the-value))
