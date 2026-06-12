#lang racket

;; Note that for a real implementation, Racket has a
;; `filename-extension` in its standard library, but don't use it here
;; since it requires a proper name (fails on ""), returns a byte-string,
;; and handles path values so might run into problems with unicode
;; string inputs.

(define (string-extension x)
  (cadr (regexp-match #px"(\\.[[:alnum:]]+|)$" x)))

(define examples '("http://example.com/download.tar.gz"
                   "CharacterModel.3DS"
                   ".desktop"
                   "document"
                   "document.txt_backup"
                   "/etc/pam.d/login"))

(for ([x (in-list examples)])
  (printf "~a | ~a\n" (~a x #:width 34) (string-extension x)))
