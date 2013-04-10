(print (int \a)) ; prints "97"
(print (char 97)) ; prints \a

; Unicode is also available, as Clojure uses the underlying java Strings & chars
(print (int \π))  ; prints 960
(print (char 960)) ; prints \π
