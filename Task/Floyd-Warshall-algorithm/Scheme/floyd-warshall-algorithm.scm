;;; Floyd-Warshall algorithm.
;;;
;;; See https://en.wikipedia.org/w/index.php?title=Floyd%E2%80%93Warshall_algorithm&oldid=1082310013
;;;

(import (scheme base))
(import (scheme cxr))
(import (scheme write))

;;;
;;; A square array will be represented by a cons-pair:
;;;
;;;    (vector-of-length n-squared . n)
;;;
;;; Arrays are indexed *starting at one*.
;;;

(define (make-arr n fill)
  (cons (make-vector (* n n) fill) n))

(define (arr-set! arr i j x)
  (let ((vec (car arr))
        (n (cdr arr)))
    (vector-set! vec (+ (- i 1) (* n (- j 1))) x)))

(define (arr-ref arr i j)
  (let ((vec (car arr))
        (n (cdr arr)))
    (vector-ref vec (+ (- i 1) (* n (- j 1))))))

;;;
;;; Floyd-Warshall.
;;;
;;; Input is a list of length-3 lists representing edges; each entry
;;; is:
;;;
;;;    (start-vertex edge-weight end-vertex)
;;;
;;; where vertex identifiers are (to help keep this example brief)
;;; integers from 1 .. n.
;;;

(define (floyd-warshall edges)

  (define n
    ;; Set n to the maximum vertex number. By design, n also equals
    ;; the number of vertices.
    (max (apply max (map car edges))
         (apply max (map caddr edges))))

  (define distance (make-arr n +inf.0))
  (define next-vertex (make-arr n #f))

  ;; Initialize "distance" and "next-vertex".
  (for-each (lambda (edge)
              (let ((u (car edge))
                    (weight (cadr edge))
                    (v (caddr edge)))
                (arr-set! distance u v weight)
                (arr-set! next-vertex u v v)))
            edges)
  (do ((v 1 (+ v 1)))
      ((< n v))
    (arr-set! distance v v 0)
    (arr-set! next-vertex v v v))

  ;; Perform the algorithm.
  (do ((k 1 (+ k 1)))
      ((< n k))
    (do ((i 1 (+ i 1)))
        ((< n i))
      (do ((j 1 (+ j 1)))
          ((< n j))
        (let ((dist-ij (arr-ref distance i j))
              (dist-ik (arr-ref distance i k))
              (dist-kj (arr-ref distance k j)))
          (let ((dist-ik+dist-kj (+ dist-ik dist-kj)))
            (when (< dist-ik+dist-kj dist-ij)
              (arr-set! distance i j dist-ik+dist-kj)
              (arr-set! next-vertex i j
                        (arr-ref next-vertex i k))))))))

  ;; Return the results.
  (values n distance next-vertex))

;;;
;;; Path reconstruction from the "next-vertex" array.
;;;
;;; The return value is a list of vertices.
;;;

(define (find-path next-vertex u v)
  (if (not (arr-ref next-vertex u v))
      (list)
      (let loop ((u u)
                 (path (list u)))
        (if (= u v)
            (reverse path)
            (let ((u^ (arr-ref next-vertex u v)))
              (loop u^ (cons u^ path)))))))

(define (display-path path)
  (let loop ((p path))
    (cond ((null? p))
          ((null? (cdr p)) (display (car p)))
          (else (display (car p))
                (display " -> ")
                (loop (cdr p))))))

(define example-graph
  '((1 -2 3)
    (3 2 4)
    (4 -1 2)
    (2 4 1)
    (2 3 3)))

(let-values (((n distance next-vertex)
              (floyd-warshall example-graph)))
  (display " pair   distance    path")
  (newline)
  (display "------------------------------------")
  (newline)
  (do ((u 1 (+ u 1)))
      ((< n u))
    (do ((v 1 (+ v 1)))
        ((< n v))
      (unless (= u v)
        (display u)
        (display " -> ")
        (display v)
        (let* ((s (number->string (arr-ref distance u v)))
               (slen (string-length s))
               (padding (- 7 slen)))
          (display (make-string padding #\space))
          (display s))
        (display "      ")
        (display-path (find-path next-vertex u v))
        (newline)))))
