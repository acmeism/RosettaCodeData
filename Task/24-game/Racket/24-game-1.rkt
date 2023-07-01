#lang racket

(define (interprete expr numbers)
  ;; the cashe for used numbers
  (define cashe numbers)

  ;; updating the cashe and handling invalid cases
  (define (update-cashe! x)
    (unless (member x numbers) (error "Number is not in the given set:" x))
    (unless (member x cashe)   (error "Number is used more times then it was given:" x))
    (set! cashe (remq x cashe)))

  ;; the parser
  (define parse
    (match-lambda
      ;; parsing arythmetics
      [`(,x ... + ,y ...) (+ (parse x) (parse y))]
      [`(,x ... - ,y ...) (- (parse x) (parse y))]
      [`(,x ... * ,y ...) (* (parse x) (parse y))]
      [`(,x ... / ,y ...) (/ (parse x) (parse y))]
      [`(,x ,op ,y ...)   (error "Unknown operator: " op)]
      ;; opening redundant brackets
      [`(,expr)           (parse expr)]
      ;; parsing numbers
      [(? number? x)      (update-cashe! x) x]
      ;; unknown token
      [x                  (error "Not a number: " x)]))

  ;; parse the expresion
  (define result (parse expr))

  ;; return the result if cashe is empty
  (if (empty? cashe)
      result
      (error "You didn`t use all numbers!")))
