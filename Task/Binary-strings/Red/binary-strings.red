Red []
s: copy "abc"   ;; string creation

s: none ;; destruction
t: "Abc"
if t == "abc" [print "equal case"]              ;; comparison , case sensitive
if t = "abc" [print "equal (case insensitive)"]  ;; comparison , case insensitive
s: copy ""                                        ;; copying string
if empty? s [print "string is empty "]          ;; check if string is empty
append s #"a"                                    ;; append byte
substr: copy/part at "1234" 3 2               ;; ~ substr ("1234" ,3,2) , red has 1 based indices !
?? substr
s: replace/all "abcabcabc" "bc" "x"             ;; replace all "bc" by "x"
?? s
s: append "hello " "world"                        ;; join 2 strings
?? s
s: rejoin ["hello " "world" " !"]                   ;; join multiple strings
?? s
