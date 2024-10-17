; binary tree helpers from "Structure and Interpretation of Computer Programs" 2.3.3
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

; returns a list of leftmost nodes from each level of the tree
(define (descend tree ls)
  (if (null? (left-branch tree))
    (cons tree ls)
    (descend (left-branch tree) (cons tree ls))))

; updates the list to contain leftmost nodes from each remaining level
(define (ascend ls)
  (cond
    ((and (null? (cdr ls)) (null? (right-branch (car ls)))) '())
    ((null? (right-branch (car ls))) (cdr ls))
    (else
      (let ((ls (cons (right-branch (car ls))
		  (cdr ls))))
	    (if (null? (left-branch (car ls)))
	      ls
	      (descend (left-branch (car ls)) ls))))))

; loops thru each list until the end (true) or nodes are unequal (false)
(define (same-fringe? t1 t2)
  (let next ((l1 (descend t1 '()))
	     (l2 (descend t2 '())))
    (cond
      ((and (null? l1) (null? l2)) #t)
      ((or (null? l1)
	   (null? l2)
	   (not (eq? (entry (car l1)) (entry (car l2))))) #f)
      (else (next (ascend l1) (ascend l2))))))
