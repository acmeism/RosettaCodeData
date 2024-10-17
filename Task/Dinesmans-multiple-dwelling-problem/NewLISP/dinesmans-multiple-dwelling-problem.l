;; Iterate over all permutations of a list, and
;; call a function on each.
(define (permute permute.seq permute.func (permute.built '()))
  (if (null? permute.seq)
    (permute.func permute.built)
    (let (seq (copy permute.seq))
      (dotimes (i (length seq))
        (unless (zero? i) (rotate seq -1))
        (permute
          (rest seq)
          permute.func
          (cons (first seq) permute.built))))))

(define (adjacent a b lst)
  (= 1 (abs (- (find a lst)
               (find b lst)))))

(define (check lst)
  (if
    (and
      (< (find 'baker lst) 4)
      (> (find 'cooper lst) 0)
      (not (member (find 'fletcher lst) '(0 4)))
      (> (find 'miller lst) (find 'cooper lst))
      (not (adjacent 'smith 'fletcher lst))
      (not (adjacent 'cooper 'fletcher lst)))
    (println lst)))

(permute '(baker cooper fletcher miller smith) check)

(smith cooper baker fletcher miller)
