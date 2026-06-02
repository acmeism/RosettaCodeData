print to integer! first "a" ;; == 97
print to integer! #"a"      ;; == 97
print to binary! "a"        ;; == #{61}
print to char! 97           ;; == a
print to char! 0#61         ;; == a  ;; available only in Rebol3
print #"^(61)"              ;; == a
print to-hex #"a"           ;; == 61 ;; since Rebol 3.20.0
