#lang racket

(require net/url)

(define (lookup-MAC-address addr)
  (port->string
   (get-pure-port
    (url "http" #f "api.macvendors.com" #f #t (list (path/param addr null)) null #f))))

(module+ test
(for ((i (in-list '("88:53:2E:67:07:BE"
                    "FC:FB:FB:01:FA:21"
                    "D4:F4:6F:C9:EF:8D"))))
  (printf "~a\t~a~%" i (lookup-MAC-address i))))
