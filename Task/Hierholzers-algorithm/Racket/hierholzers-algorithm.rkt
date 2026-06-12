#lang racket

(require racket/hash)

;; Main function that runs the algorithm on two example graphs
(define (main)
  ;; First adjacency list example
  (define adj-list1
    '((1)     ; Vertex 0 connects to vertex 1
      (2)     ; Vertex 1 connects to vertex 2
      (0)))   ; Vertex 2 connects to vertex 0

  (print-circuit adj-list1)

  ;; Second adjacency list example
  (define adj-list2
    '((1 6)   ; Vertex 0 connects to vertices 1, 6
      (2)     ; Vertex 1 connects to vertex 2
      (0 3)   ; Vertex 2 connects to vertices 0, 3
      (4)     ; Vertex 3 connects to vertex 4
      (2 5)   ; Vertex 4 connects to vertices 2, 5
      (0)     ; Vertex 5 connects to vertex 0
      (4)))   ; Vertex 6 connects to vertex 4

  (print-circuit adj-list2))

;; Print the Eulerian circuit
(define (print-circuit adj-list)
  (if (null? adj-list)
      (void)
      (let ([adj-hash (create-adjacency-hash adj-list)]
            [start-vertex 0])
        (define final-circuit
          (find-circuit start-vertex (list start-vertex) '() adj-hash))
        (print-result (reverse final-circuit)))))

;; Convert adjacency list to hash table
(define (create-adjacency-hash adj-list)
  (for/hash ([i (in-naturals 0)]
             [neighbors adj-list])
    (values i neighbors)))

;; Main Hierholzer algorithm implementation
(define (find-circuit current-vertex path circuit adj-hash)
  (cond
    [(null? path) circuit]
    [else
     (define neighbors (hash-ref adj-hash current-vertex '()))
     (cond
       [(null? neighbors)
        ;; No more neighbors - backtrack
        (define new-circuit (cons current-vertex circuit))
        (cond
          [(null? path) new-circuit]
          [else
           (define-values (new-current rest-path) (values (car path) (cdr path)))
           (find-circuit new-current rest-path new-circuit adj-hash)])]
       [else
        ;; Has neighbors - move forward
        (define next-vertex (last neighbors))
        (define remaining-neighbors (drop-right neighbors 1))
        (define new-adj-hash (hash-set adj-hash current-vertex remaining-neighbors))
        (define new-path (cons current-vertex path))
        (find-circuit next-vertex new-path circuit new-adj-hash)])]))

;; Print the result with arrows
(define (print-result lst)
  (cond
    [(null? lst) (newline)]
    [(null? (cdr lst)) (printf "~a~n" (car lst))]
    [else
     (printf "~a => " (car lst))
     (print-result (cdr lst))]))

;; Run main
(main)
