;; Project : Palindrome detection
;; Date    : 2018/03/06
;; Author : Gal Zsolt [~ CalmoSoft ~]
;; Email   : <calmosoft@gmail.com>

(defun palindrome(x)
          (if (string= x (reverse x))
          (format t "~d" ": palindrome" (format t x))
          (format t "~d" ": not palindrome" (format t x))))
(terpri)
(setq x "radar")
(palindrome x)
(terpri)
(setq x "books")
(palindrome x)
(terpri)
