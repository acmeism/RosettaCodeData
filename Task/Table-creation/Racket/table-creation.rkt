#lang racket
(require db)
(define postal (sqlite3-connect #:database "/tmp/postal.db" #:mode 'create))
