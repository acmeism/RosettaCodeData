;; Using SRFI-1, R6RS, or R7RS association lists.

;; Because the task calls for ‘arrays’, I start with actual arrays
;; rather than lists.
(define array1 (vector "a" "b" "c" "d"))
(define array2 (vector 1 2 3 4))

;; Making the hash is just a simple list operation.
(define dictionary (map cons (vector->list array1)
                        (vector->list array2)))

;; Now you can look up associations with assoc.
(write (assoc "b" dictionary)) (newline)
(write (assoc "d" dictionary)) (newline)

;; USING CHICKEN 5 SCHEME, OUTPUT FROM EITHER
;; ‘csc -R srfi-1 thisprog.scm && ./thisprog’
;; OR ‘csc -R r7rs thisprog.scm && ./thisprog’,
;; AND ALSO TESTED IN CHEZ SCHEME (R6RS):
;;
;; ("b" . 2)
;; ("d" . 4)
;;
