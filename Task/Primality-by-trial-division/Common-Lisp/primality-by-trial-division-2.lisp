;; Project : Primality by trial division
;; Date    : 2018/03/06
;; Author : Gal Zsolt [~ CalmoSoft ~]
;; Email   : <calmosoft@gmail.com>

(defun prime(n)
         (setq flag 0)
         (loop for i from 2 to (- n 1) do
                 (if (= (mod n i) 0)
                     (setq flag 1)))
                 (if (= flag 0)
                     (format t "~d is a prime number" n)
                     (format t "~d is not a prime number" n)))
(prime 7)
(prime 8)
