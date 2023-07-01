; Basic usage
> (reduce #'* '(1 2 3 4 5))
120
; Using an initial value
> (reduce #'+ '(1 2 3 4 5) :initial-value 100)
115
; Using only a subsequence
> (reduce #'+ '(1 2 3 4 5) :start 1 :end 4)
9
; Apply a function to each element first
> (reduce #'+ '((a 1) (b 2) (c 3)) :key #'cadr)
6
; Right-associative reduction
> (reduce #'expt '(2 3 4) :from-end T)
2417851639229258349412352
; Compare with
> (reduce #'expt '(2 3 4))
4096
