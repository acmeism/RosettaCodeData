#lang racket
(require rsound)
; 440 Hz, 50% volume, 5 seconds
(play (make-tone 440 0.50 (* 5 FRAME-RATE)))
