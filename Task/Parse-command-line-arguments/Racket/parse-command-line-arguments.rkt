#!/usr/bin/env racket
#lang racket

(define loglevel 1)
(define mode 'new)
(define ops '())
(define root #f)

(command-line
 #:multi
 [("-v" "--verbose")    "more verbose"      (set! loglevel (add1 loglevel))]
 [("-q" "--quiet")      "be quiet"          (set! loglevel 0)]
 #:once-any
 [("-i" "--in-place")   "edit in-place"     (set! mode 'in-place)]
 [("-c" "--create-new") "create a new file" (set! mode 'new)]
 [("-n" "--dry-run")    "do nothing"        (set! mode #f)]
 #:once-each
 [("-d" "--directory") dir "work in a given directory" (set! root dir)]
 #:help-labels "operations to perform:"
 #:multi
 [("+l" "++line") "add a line"    (set! ops `(,@ops "add"))]
 [("-l" "--line") "delete a line" (set! ops `(,@ops "delete"))]
 [("-e" "--edit") "edit a line"   (set! ops `(,@ops "edit"))]
 #:args (file . files)
 (printf "Running on: ~a\n" (string-join (cons file files) ", "))
 (when root (printf "In Dir:     ~a\n" root))
 (printf "Mode:       ~s\n" mode)
 (printf "Log level:  ~s\n" loglevel)
 (printf "Operations: ~a\n" (string-join ops ", ")))
