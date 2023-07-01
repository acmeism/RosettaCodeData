#lang racket/base

(require racket/hash)

(module+ test
  (require rackunit)

  (define base-data (hash "name"	"Rocket Skates"
                          "price"	12.75
                          "color"	"yellow"))

  (define update-data (hash "price"	15.25
                            "color"	"red"
                            "year"	1974))

  (hash-union base-data update-data #:combine (λ (a b) b)))
