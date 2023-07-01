#lang racket/base

;; Racket's `directory-list' produces a sorted list of files
(define (ls) (for-each displayln (directory-list)))

;; Code to run when this file is running directly
(module+ main
  (ls))

(module+ test
  (require tests/eli-tester racket/port racket/file)
  (define (make-directory-tree)
    (make-directory* "foo/bar")
    (for ([f '("1" "2" "a" "b")])
      (with-output-to-file (format "foo/bar/~a"f) #:exists 'replace newline)))
  (make-directory-tree)
  (define (ls/str dir)
    (parameterize ([current-directory dir]) (with-output-to-string ls)))
  (test (ls/str "foo") => "bar\n"
        (ls/str "foo/bar") => "1\n2\na\nb\n"))
