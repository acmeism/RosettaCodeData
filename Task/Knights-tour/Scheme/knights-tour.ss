;;/usr/bin/petite
;;encoding:utf-8
;;Author:Panda
;;Mail:panbaoxiang@hotmail.com
;;Created Time:Thu 29 Jan 2015 10:18:49 AM CST
;;Description:

;;size of the chessboard
(define X 8)
(define Y 8)
;;position is an integer that could be decoded into the x coordinate and y coordinate
 (define(decode position)
  (cons (div position Y) (remainder position Y)))
 ;;record the paths and number of territories you have conquered
 (define dictionary '())
 (define counter 1)
 ;;define the forbiddend territories(conquered and cul-de-sac)
 (define forbiddened '())
 ;;renew when havn't conquered the world.
 (define (renew position)
  (define possible
   (let ((rules (list (+ (* 2 Y) 1 position)
                      (+ (* 2 Y) -1 position)
                      (+ (* -2 Y) 1 position)
                      (+ (* -2 Y) -1 position)
                      (+ Y 2 position)
                      (+ Y -2 position)
                      (- position Y 2)
                      (- position Y -2))))
    (filter (lambda(x) (not (or (member x forbiddened) (< x 0) (>= x (* X Y))))) rules)))
  (if (null? possible)
   (begin (set! forbiddened (cons (car dictionary) forbiddened))
          (set! dictionary (cdr dictionary))
          (set! counter (- counter 1))
          (car dictionary))
   (begin (set! dictionary (cons (car possible) dictionary))
          (set! forbiddened dictionary)
          (set! counter (+ counter 1))
          (car possible))))
;;go to search
(define (go position)
 (if (= counter (* X Y))
  (begin
  (set! result (reverse dictionary))
  (display (map (lambda(x) (decode x)) result)))
  (go (renew position))))
