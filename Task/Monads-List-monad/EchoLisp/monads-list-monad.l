;; -> and ->> are the pipeline operators
;; (-> x f g h) = (h (g ( f x)))
;; (->> x f (g a) h) = (h (g a ( f x)))

(define (List.unit elem)  (append '(List) elem))
(define (List.bind xs f)  (List.unit (->> xs rest (map f)  (map rest) (apply append))))
(define (List.lift f)     (lambda(elem) (List.unit (f elem))))

(define List.square  (List.lift (lambda(x) (*  x x))))
(define List.cube    (List.lift (lambda(x) (* x x x))))
(define List.tostr   (List.lift number->string))

;; composition

(-> '(List 1 -2 3 -5) (List.bind List.cube) (List.bind List.tostr))
    → (List "1" "-8" "27" "-125")
;; or
(-> '(1 -2 3 -5) List.unit (List.bind List.cube) (List.bind List.tostr))
     → (List "1" "-8" "27" "-125")
