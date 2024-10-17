; A way to get pi.
(define pi (acos -1))

; Print the value of e^(i*pi) + 1 -- should be 0.
(printf "e^(i*pi) + 1 = ~a~%" (+ (exp (* +i pi)) 1))
