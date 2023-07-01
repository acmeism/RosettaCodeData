#lang racket/base
(require sql db)

(define pgc
  ; Don't actually inline sensitive data ;)
  (postgresql-connect #:user     "resu"
                      #:database "esabatad"
                      #:server   "example.com"
                      #:port     5432
                      #:password "s3>r37P455"))

(define update-player
  (parameterize ((current-sql-dialect 'postgresql))
                (update players
                        #:set [name ?] [score ?] [active ?]
                        #:where [jerseyNum ?])))

(apply query
       pgc
       update-player
       '("Smith, Steve" 42 #t 99))
