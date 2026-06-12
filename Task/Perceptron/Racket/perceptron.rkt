#lang racket
(require 2htdp/universe
         2htdp/image)

(define (activate s) (if (positive? s) 1 -1))

;; ---------------------------------------------------------------------------------------------------
;; PERCEPTRON
(define perceptron%
  (class object%
    (super-new)
    (init-field n)

    (field [weights (build-vector n (λ (i) (- (* (random) 2) 1)))])

    (define c 0.001)

    (define/public (feed-forward inputs)
      (unless (= (vector-length inputs) (vector-length weights))
        (error 'feed-forward "weights and inputs lengths mismatch"))
      (activate (for/sum ((i (in-vector inputs)) (w (in-vector weights))) (* i w))))

    (define/public (train! inputs desired)
      (let ((error (- desired (feed-forward inputs))))
        (set! weights (vector-map (λ (w i) (+ w (* c error i))) weights inputs))))))

;; ---------------------------------------------------------------------------------------------------
;; TRAINING
(struct training-data (inputs answer))

(define (make-training-data x y f)
  (training-data (vector x y 1) (activate (- (f x) y))))

;; ---------------------------------------------------------------------------------------------------
;; DEMO
(define (demo)
  (struct demonstration (p w h f i))

  (define (draw-classification-space p w h scl n)
    (for/fold ((scn (place-image (text (~a (get-field weights p)) 12 "red")
                                 (* scl (/ w 2))
                                 (* scl (/ h 2))
                                 (empty-scene (* w scl) (* h scl)))))
              ((_ (in-range n)))
      (let* ((x (* (random) w))
             (y (* (random) h))
             (guess+? (positive? (send p feed-forward (vector x y 1)))))
        (place-image (rectangle 4 4 (if guess+? 'solid 'outline) (if guess+? 'red 'black))
                     (- (* scl x) 2) (- (* scl (- h y)) 2)
                     scn))))

  (define the-demo
    (let ((w 640/100) (h 360/100) (f (λ (x) (+ (* x 0.7) 0.8))))
      (demonstration (new perceptron% [n 3]) w h f 0)))

  (define (demo-train p w h f)
    (let ((td (make-training-data (* (random) w) (* (random) h) f)))
      (send p train! (training-data-inputs td) (training-data-answer td))))

  (define tick-handler
    (match-lambda
      [(and d (demonstration p w h f i))
       (for ((_ (in-range 100))) (demo-train p w h f))
       (struct-copy demonstration d [i (+ 100 i)])]))

  (define draw-demo (match-lambda
                      [(demonstration p w h f i)
                       (let ((scl 100))
                         (scene+line (place-image (text (~a i) 24 "magenta")
                                                  (* scl (/ w 2))
                                                  (* scl (/ h 3))
                                                  (draw-classification-space p w h scl 1000))
                                     0 (* scl (- h (f 0))) (* scl w) (* scl (- h (f w))) "red"))]))

  (big-bang the-demo (to-draw draw-demo) (on-tick tick-handler)))

(module+ main (demo))
