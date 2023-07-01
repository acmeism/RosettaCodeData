#lang racket

(require net/private/ip)

(define (bytes->hex bs)
  (string-append* (map (λ(n) (~r n #:base 16 #:min-width 2 #:pad-string "0"))
                       (bytes->list bs))))

(define (parse-ip str)
  (define-values [ipstr portstr]
    (match str
      [(regexp #rx"^([0-9.]+):([0-9]+)$" (list _ i p)) (values i p)]
      [(regexp #rx"^\\[([0-9a-fA-F:]+)\\]:([0-9]+)$" (list _ i p)) (values i p)]
      [_ (values str "")]))
  (define ip (make-ip-address ipstr))
  (define 4? (ipv4? ip))
  (define hex (bytes->hex ((if 4? ipv4-bytes ipv6-bytes) ip)))
  (displayln (~a (~a str #:min-width 30)
                 " "
                 (~a hex #:min-width 32 #:align 'right)
                 " ipv" (if 4? "4" "6") " " portstr)))

(for-each parse-ip
          '("127.0.0.1"
            "127.0.0.1:80"
            "::1"
            "[::1]:80"
            "2605:2700:0:3::4713:93e3"
            "[2605:2700:0:3::4713:93e3]:80"))
