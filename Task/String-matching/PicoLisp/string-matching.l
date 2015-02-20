: (pre? "ab" "abcd")
-> "abcd"
: (pre? "xy" "abcd")
-> NIL

: (sub? "bc" "abcd")
-> "abcd"
: (sub? "xy" "abcd")
-> NIL

: (tail (chop "cd") (chop "abcd"))
-> ("c" "d")
: (tail (chop "xy") (chop "abcd"))
-> NIL


(de positions (Pat Str)
   (setq Pat (chop Pat))
   (make
      (for ((I . L) (chop Str) L (cdr L))
         (and (head Pat L) (link I)) ) ) )

: (positions "bc" "abcdabcd")
-> (2 6)
