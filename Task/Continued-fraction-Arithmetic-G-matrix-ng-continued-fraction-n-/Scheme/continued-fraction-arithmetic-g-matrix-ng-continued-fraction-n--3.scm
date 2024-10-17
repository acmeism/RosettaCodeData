;;;-------------------------------------------------------------------
;;;
;;; With continued fractions as SRFI-41 lazy lists and homographic
;;; functions as vectors of length 4.
;;;

(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

(import (scheme base))
(import (scheme case-lambda))
(import (scheme write))
(import (srfi 41))                      ; Streams (lazy lists).

;;;-------------------------------------------------------------------
;;;
;;; Some simple continued fractions.
;;;

(define nil           ; A "continued fraction" that contains no terms.
  stream-null)

(define (repeat term)               ; Infinite repetition of one term.
  (stream-cons term (repeat term)))

(define sqrt2                           ; The square root of two.
  (stream-cons 1 (repeat 2)))

;;;-------------------------------------------------------------------
;;;
;;; Continued fraction for a rational number.
;;;

(define r2cf
  (case-lambda
    ((n d)
     (letrec ((recurs
               (stream-lambda (n d)
                 (if (zero? d)
                     stream-null
                     (let-values (((q r) (floor/ n d)))
                       (stream-cons q (recurs d r)))))))
       (recurs n d)))
    ((ratnum)
     (let ((ratnum (exact ratnum)))
       (r2cf (numerator ratnum)
             (denominator ratnum))))))

;;;-------------------------------------------------------------------
;;;
;;; Application of a homographic function to a continued fraction.
;;;

(define-stream (apply-ng4 ng4 other-cf)
  (define (eject-term a1 a b1 b other-cf term)
    (apply-ng4 (vector b1 b (- a1 (* b1 term)) (- a (* b term)))
               other-cf))
  (define (absorb-term a1 a b1 b other-cf)
    (if (stream-null? other-cf)
        (apply-ng4 (vector a1 a1 b1 b1) other-cf)
        (let ((term (stream-car other-cf))
              (rest (stream-cdr other-cf)))
          (apply-ng4 (vector (+ a (* a1 term)) a1
                             (+ b (* b1 term)) b1)
                     rest))))
  (let ((a1 (vector-ref ng4 0))
        (a  (vector-ref ng4 1))
        (b1 (vector-ref ng4 2))
        (b  (vector-ref ng4 3)))
    (cond ((and (zero? b1) (zero? b)) stream-null)
          ((or (zero? b1) (zero? b)) (absorb-term a1 a b1 b other-cf))
          (else
           (let ((q1 (floor-quotient a1 b1))
                 (q  (floor-quotient a b)))
             (if (= q1 q)
                 (stream-cons q (eject-term a1 a b1 b other-cf q))
                 (absorb-term a1 a b1 b other-cf)))))))

;;;-------------------------------------------------------------------
;;;
;;; Particular homographic function applications.
;;;

(define (add-number cf num)
  (if (integer? num)
      (apply-ng4 (vector 1 num 0 1) cf)
      (let ((num (exact num)))
        (let ((n (numerator num))
              (d (denominator num)))
          (apply-ng4 (vector d n 0 d) cf)))))

(define (mul-number cf num)
  (if (integer? num)
      (apply-ng4 (vector num 0 0 1) cf)
      (let ((num (exact num)))
        (let ((n (numerator num))
              (d (denominator num)))
          (apply-ng4 (vector n 0 0 d) cf)))))

(define (div-number cf num)
  (if (integer? num)
      (apply-ng4 (vector 1 0 0 num) cf)
      (let ((num (exact num)))
        (let ((n (numerator num))
              (d (denominator num)))
          (apply-ng4 (vector d 0 0 n) cf)))))

(define (reciprocal cf) (apply-ng4 #(0 1 1 0) cf))

;;;-------------------------------------------------------------------
;;;
;;; cf2string: conversion from a continued fraction to a string.
;;;

(define *max-terms* (make-parameter 20))

(define cf2string
  (case-lambda
    ((cf) (cf2string cf (*max-terms*)))
    ((cf max-terms)
     (let loop ((i 0)
                (s "[")
                (strm cf))
       (if (stream-null? strm)
           (string-append s "]")
           (let ((term (stream-car strm))
                 (tail (stream-cdr strm)))
             (if (= i max-terms)
                 (string-append s ",...]")
                 (let ((separator (case i
                                    ((0) "")
                                    ((1) ";")
                                    (else ",")))
                       (term-str (number->string term)))
                   (loop (+ i 1)
                         (string-append s separator term-str)
                         tail)))))))))

;;;-------------------------------------------------------------------

(define (show expression cf)
  (display expression)
  (display " => ")
  (display (cf2string cf))
  (newline))

(define cf:13/11 (r2cf 13/11))
(define cf:22/7 (r2cf 22/7))
(define cf:1/sqrt2 (reciprocal sqrt2))

(show "13/11" cf:13/11)
(show "22/7" cf:22/7)
(show "sqrt(2)" sqrt2)
(show "13/11 + 1/2" (add-number cf:13/11 1/2))
(show "22/7 + 1/2" (add-number cf:22/7 1/2))
(show "(22/7)/4" (div-number cf:22/7 4))
(show "(22/7)*(1/4)" (mul-number cf:22/7 1/4))
(show "(22/49)/(4/7)" (div-number (r2cf 22 49) 4/7))
(show "(22/49)*(7/4)" (mul-number (r2cf 22/49) 7/4))
(show "1/sqrt(2)" cf:1/sqrt2)

;; The simplest way to get (1 + 1/sqrt(2))/2.
(show "(sqrt(2) + 2)/4" (apply-ng4 #(1 2 0 4) sqrt2))

;; Getting it in a more obvious way.
(show "(1/sqrt(2) + 1)/2)" (div-number (add-number cf:1/sqrt2 1) 2))

;;;-------------------------------------------------------------------
