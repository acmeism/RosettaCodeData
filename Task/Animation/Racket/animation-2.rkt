#lang racket
(require racket/match)
(require 2htdp/image)
(require 2htdp/universe)

; program state
; value -> no. of rotations of string
; step -> number (positive for right rotations, else negative)
(struct rotations (value step) #:transparent)

(define STR "Hello World! ")
(define LEN (string-length STR))

; font
(define COLOR "red")
(define TEXT-SIZE 16)   ;; pixels

(define (render rots)
  (define val (rotations-value rots))
  (text (string-append (substring STR val)
                       (substring STR 0 val))
        TEXT-SIZE
        COLOR))

(define (update rots)
  (match rots
      [(rotations val dir)
       (rotations (modulo (+ val dir) LEN) dir)]))

; reverse direction on mouse click
(define (handle-mouse rots x y event)
  (case event
    ; "button-up" indicates mouse click
    [("button-up") (rotations (rotations-value rots)
                              (- (rotations-step rots)))]
    [else rots]))

; start GUI, with given event handlers
(big-bang (rotations 0 1)
  [to-draw render]
  [on-tick update]
  [on-mouse handle-mouse])
