;; sorts a vector of objects in place
;; proc is an user defined comparison procedure

(define (bubble-sort V proc)
(define length (vector-length V))
    (for* ((i (in-range 0 (1- length))) (j (in-range (1+ i) length)))
    (unless (proc (vector-ref V i) (vector-ref V j)) (vector-swap! V i j)))
    V)


(define V #( albert antoinette elvis zen simon))
(define (sort/length a b) ;; sort by string length
    (< (string-length a) (string-length b)))

(bubble-sort V sort/length)
    → #(zen simon elvis albert antoinette)
