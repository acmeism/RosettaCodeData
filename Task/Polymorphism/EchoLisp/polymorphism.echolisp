(struct Point ((real:x 0) (real:y 0)))
(struct Circle ((real:x 0) (real:y 0) (real:r 1)))

(define-method (print Point:p) (printf "📌 [%d %d]" p.x p.y))
(define-method (print Circle:c) (printf "⭕️ center:[%d %d] radius:%d" c.x c.y c.r))

(print (Point 5 6))
    → 📌 [5 6]
(print (Circle 2 3 4))
    → ⭕️ center:[2 3] radius:4

;; Accessors :
;; (Point-x p), (Point-y p) or p.x, p.y
;; (Circle-x c), c.x , etc.
;; Setters :
;; (set-Point-x! p value), (set-Circle-r!  c value)  etc.

;; Constructors
;; (Point) (Point x) (Point x y)
;; (Circle) (circle x) (Circle x y) (Circle x y r)

;;Copy
(print (copy (Circle 3 3 )))
    →  ⭕️ center:[3 3] radius:1

;;Assignment (to a variable)
(define my-point (Point 7 8))

;;Destructor : none. Points and Circles are garbage collected.

;;Type checking
(Point "here" "there")
    💣 error: Real : type-check failure : here → 'Point:x'

;;Initializer procedure
(struct Circle ((x 0) (y 0) (r 1) d) #:initialize circle-init)
(define (circle-init Circle:c) (set-Circle-d! c (* 2 PI c.r)))
(define-method (print Circle:c)
    (printf "⭕️ center:[%d %d] radius:%d diameter:%d" c.x c.y c.r c.d))

(print (Circle 0 0 10))
    → ⭕️ center:[0 0] radius:10 diameter:62.83185307179586
