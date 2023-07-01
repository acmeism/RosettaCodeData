#lang racket

(define items '((map 9 150) (compass 13 35) (water 153 200) (sandwich 50 160)
      (glucose 15 60) (tin 68 45)(banana 27 60) (apple 39 40)
      (cheese 23 30) (beer 52 10) (cream 11 70) (camera 32 30)
      (T-shirt 24 15) (trousers 48 10) (umbrella 73 40)
      (trousers 42 70) (overclothes 43 75) (notecase 22 80)
      (glasses 7 20) (towel 18 12) (socks 4 50) (book 30 10)))

(define max-weight 400)

(define (item-value item)
  (caddr item))

(define (item-weight item)
  (cadr item))

(define (pack-weight pack)
  (apply + (map item-weight pack)))

(define (pack-value pack)
  (apply + (map item-value pack)))

(define (max-pack-value pack-with pack-without max-weight)
  (if (and
       (not (> (pack-weight pack-with) max-weight))
       (> (pack-value pack-with) (pack-value pack-without)))
      pack-with pack-without))

(define (display-solution pack)
    (displayln (list 'weight: (pack-weight pack)
                     'value:  (pack-value pack)
                     'items:  (map car pack))))
