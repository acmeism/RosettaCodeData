#lang racket

(define (no-arg) (void))

(define (two-args a b) (void)) ;arguments are always named

(define (varargs . args) (void)) ;the extra arguments are stored in a list

(define (varargs2 a . args) (void)) ;one obligatory argument and the rest are contained in the list

(define (optional-arg (a 5)) (void)) ;a defaults to 5
