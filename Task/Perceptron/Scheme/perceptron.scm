(import (scheme base)
        (scheme case-lambda)
        (scheme write)
        (srfi 27))      ; for random numbers

(random-source-randomize! default-random-source)

;;; Function to create a perceptron

;; num-inputs: size of input data
;; learning-rate: small number, to give rate of learning
;; returns perceptron as a function
;;         accepting 'train data -> trains on given list of data
;;                   'test data  -> returns percent correct on given list of data
;;                   'show       -> displays the perceptron weights
;; classes assumed to be 1, -1
(define (create-perceptron num-inputs learning-rate)
  (define (make-rnd-vector n) ; rnd vector, values in [-1,1]
    (let ((result (make-vector n)))
      (do ((i 0 (+ 1 i)))
        ((= i n) result)
        (vector-set! result i (- (* 2 (random-real)) 1)))))
  (define (extended input) ; add a 1 to end of vector
    (let* ((n (vector-length input))
           (result (make-vector (+ 1 n))))
      (do ((i 0 (+ 1 i)))
        ((= i n) (vector-set! result i 1)
                 result)
        (vector-set! result i (vector-ref input i)))))
  (define (predict weights extended-input)
    (let ((sum 0))
      (vector-for-each (lambda (w i) (set! sum (+ sum (* w i))))
                       weights extended-input)
      (if (positive? sum) 1 -1)))
  ;
  (let ((weights (make-rnd-vector (+ 1 num-inputs))))
    (case-lambda ; defines a function for the perceptron
      ((key)
       (when (eq? key 'show)
         (display weights) (newline)))
      ((action data)
       (case action
         ((train)
          (for-each
            (lambda (datum)
              (let* ((extended-input (extended (car datum)))
                     (error (- (cdr datum) (predict weights extended-input))))
                (set! weights (vector-map (lambda (w i) (+ w (* learning-rate error i)))
                                          weights
                                          extended-input))))
            data))
         ((test)
          (let ((count 0))
            (for-each
              (lambda (datum) (when (= (cdr datum) (predict weights (extended (car datum))))
                                (set! count (+ 1 count))))
              data)
            (inexact (* 100 (/ count (length data)))))))))))

;; create data: list of n ( #(input values) . target ) pairs
;; using formula y = mx + b, target based on if input above / below line
(define (create-data m b n)
  (define (target x y)
    (let ((fx (+ b (* m x))))
      (if (< fx y) 1 -1)))
  (define (create-datum)
    (let ((x (random-real))
          (y (random-real)))
      (cons (vector x y) (target x y))))
  ;
  (do ((data '() (cons (create-datum) data)))
    ((= n (length data)) data)))

;; train on 5000 points, show weights and result on 1000 test points
(let* ((m 0.7)
       (b 0.2)
       (perceptron (create-perceptron 2 0.001)))
  (perceptron 'train (create-data m b 5000))
  (perceptron 'show)
  (display "Percent correct on test set: ")
  (display (perceptron 'test (create-data m b 1000)))
  (newline))

;; show performance along training stages
(let* ((m 0.7) ; gradient of target line
       (b 0.2) ; y-intercept of target line
       (train-step 1000)  ; step in training set size
       (train-stop 20000) ; largest training set size
       (test-set (create-data m b 1000)) ; create a fixed test set
       (perceptron (create-perceptron 2 0.001)))
  (do ((i train-step (+ i train-step)))
    ((> i train-stop) )
    (perceptron 'train (create-data m b train-step))
    (display (string-append "Trained on " (number->string i)
                            ", percent correct is "
                            (number->string (perceptron 'test test-set))
                            "\n"))))
