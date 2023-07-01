#lang racket
(require srfi/14)
(printf "System information: ~a~%" (map system-type (list 'os 'word 'machine)))
(printf "All lowercase characters: ~a~%" (char-set->string char-set:lower-case))
(newline)
(printf "All uppercase characters: ~a~%" (char-set->string char-set:upper-case))
