#lang racket/base
(with-output-to-file "/tmp/out-file.txt" #:exists 'replace
  (lambda () (display "characters")))
