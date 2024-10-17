; A two-dimensional grid of values...

; Create an empty (all cells 0) grid of the specified size.
; Optionally, fill all cells with given value.
(define make-grid
  (lambda (size-x size-y . opt-value)
    (cons size-x (make-vector (* size-x size-y) (if (null? opt-value) 0 (car opt-value))))))

; Return the vector of all values of a grid.
(define grid-vector
  (lambda (grid)
    (cdr grid)))

; Return the X size of a grid.
(define grid-size-x
  (lambda (grid)
    (car grid)))

; Return the Y size of a grid.
(define grid-size-y
  (lambda (grid)
    (/ (vector-length (cdr grid)) (car grid))))

; Return #t if the specified x/y is within the range of the given grid.
(define grid-in-range
  (lambda (grid x y)
    (and (>= x 0) (>= y 0) (< x (grid-size-x grid)) (< y (grid-size-y grid)))))

; Return the value from the specified cell of the given grid.
; Note:  Returns 0 if x/y is out of range.
(define grid-ref
  (lambda (grid x y)
    (if (grid-in-range grid x y)
      (vector-ref (cdr grid) (+ x (* y (car grid))))
      0)))

; Store the given value into the specified cell of the given grid.
; Note:  Does nothing if x/y is out of range.
(define grid-set!
  (lambda (grid x y val)
    (when (grid-in-range grid x y)
      (vector-set! (cdr grid) (+ x (* y (car grid))) val))))

; Display the given grid, leaving correct spacing for maximum value.
; Optionally, uses a specified digit count for spacing.
; Returns the digit count of the largest grid value.
; Note:  Assumes the values in the grid are all non-negative integers.
(define grid-display
  (lambda (grid . opt-digcnt)
    ; Return count of digits in printed representation of integer.
    (define digit-count
      (lambda (int)
        (if (= int 0) 1 (1+ (exact (floor (log int 10)))))))
    ; Display the grid, leaving correct spacing for maximum value.
    (let* ((maxval (fold-left max 0 (vector->list (grid-vector grid))))
           (digcnt (if (null? opt-digcnt) (digit-count maxval) (car opt-digcnt))))
      (do ((y 0 (1+ y)))
          ((>= y (grid-size-y grid)))
        (do ((x 0 (1+ x)))
            ((>= x (grid-size-x grid)))
          (printf " ~vd" digcnt (grid-ref grid x y)))
        (printf "~%"))
      digcnt)))

; Implementation of the Abelian Sandpile Model using the above grid...

; Topple the specified cell of the given Abelian Sandpile Model grid.
; If number of grains in cell is less than 4, does nothing and returns #f.
; Otherwise, distributes 4 grains from the cell to its nearest neighbors and returns #t.
(define asm-topple
  (lambda (asm x y)
    (if (< (grid-ref asm x y) 4)
      #f
      (begin
        (grid-set! asm x y (- (grid-ref asm x y) 4))
        (grid-set! asm (1- x) y (1+ (grid-ref asm (1- x) y)))
        (grid-set! asm (1+ x) y (1+ (grid-ref asm (1+ x) y)))
        (grid-set! asm x (1- y) (1+ (grid-ref asm x (1- y))))
        (grid-set! asm x (1+ y) (1+ (grid-ref asm x (1+ y))))
        #t))))

; Repeatedly topple unstable cells in the given Abelian Sandpile Model grid
; until all cells are stable.
(define asm-stabilize
  (lambda (asm)
    (let loop ((any-toppled #f))
      (do ((y 0 (1+ y)))
          ((>= y (grid-size-y asm)))
        (do ((x 0 (1+ x)))
            ((>= x (grid-size-x asm)))
          (when (asm-topple asm x y)
            (set! any-toppled #t))))
      (when any-toppled
        (loop #f)))))

; Test the Abelian Sandpile Model on a simple grid...

(let ((asm (make-grid 9 9)))
  (grid-set! asm 4 4 64)
  (printf "Before:~%")
  (let ((digcnt (grid-display asm)))
    (asm-stabilize asm)
    (printf "After:~%")
    (grid-display asm digcnt)))
