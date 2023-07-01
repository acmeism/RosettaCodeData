(def s1 (str "abc" "def"))
(def s2 (str "ab" "cdef"))

(= s1 "abcdef")           ; true
(= s1 s2)                 ; true

(identical? s1 "abcdef")  ; false
(identical? s1 s2)        ; false
