(import (scheme base)
        (scheme inexact)
        (scheme read)
        (scheme write)
        (srfi 1))         ; for fold

;; functions copied from "Averages/Mean angle" task
(define (average l)
  (/ (fold + 0 l) (length l)))

(define pi 3.14159265358979323846264338327950288419716939937510582097)

(define (radians a)
  (* pi 1/180 a))

(define (degrees a)
  (* 180 (/ 1 pi) a))

(define (mean-angle angles)
  (let* ((angles (map radians angles))
         (cosines (map cos angles))
         (sines (map sin angles)))
    (degrees (atan (average sines) (average cosines)))))

;; -- new functions for this task
(define (time->angle time)
  (let* ((time2 ; replaces : with space in string
           (string-map (lambda (c) (if (char=? c #\:) #\space c)) time))
         (string-port (open-input-string time2))
         (hour (read string-port))
         (minutes (read string-port))
         (seconds (read string-port)))
    (/ (* 360 (+ (* hour 3600) (* minutes 60) seconds))
       (* 24 60 60))))

(define (angle->time angle)
  (let* ((nom-angle (if (negative? angle) (+ 360 angle) angle))
         (time (/ (* nom-angle 24 60 60) 360))
         (hour (exact (floor (/ time 3600))))
         (minutes (exact (floor (/ (- time (* 3600 hour)) 60))))
         (seconds (exact (floor (- time (* 3600 hour) (* 60 minutes))))))
    (string-append (number->string hour)
                   ":"
                   (number->string minutes)
                   ":"
                   (number->string seconds))))

(define (mean-time-of-day times)
  (angle->time (mean-angle (map time->angle times))))

(write (mean-time-of-day '("23:00:17" "23:40:20" "00:12:45" "00:17:19")))
(newline)
