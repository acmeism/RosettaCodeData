(import (chezscheme))
(import (srfi srfi-1))


(define (remove-self-dependency pair)
  (let ((key (car pair))
        (value (cdr pair)))
    (cons key (remq key value))))w

(define (remove-self-dependencies alist)
  (map remove-self-dependency alist))

(define (add-missing-items dependencies)
  (let loop ((items (delete-duplicates (append-map cdr dependencies) eq?))
             (out dependencies))
    (if (null? items)
        out
        (let ((item (car items)))
          (if (assq item out)
              (loop (cdr items) out)
              (loop (cdr items) (cons (cons item '()) out)))))))

(define (lift dependencies batch)
  (let loop ((dependencies dependencies)
             (out '()))
    (if (null? dependencies)
        out
        (let ((key (caar dependencies))
              (value (cdar dependencies)))
          (if (null? value)
              (loop (cdr dependencies) out)
              (loop (cdr dependencies)
                    (cons (cons key (lset-difference eq? value batch))
                          out)))))))

(define (topological-sort dependencies)
  (let* ((dependencies (remove-self-dependencies dependencies))
         (dependencies (add-missing-items dependencies)))
    (let loop ((out '())
               (dependencies dependencies))
      (if (null? dependencies)
          (reverse out)
          (let ((batch (map car (filter (lambda (pair) (null? (cdr pair))) dependencies))))
            (if (null? batch)
                #f
                (loop (cons batch out) (lift dependencies batch))))))))


(define example
  '((des_system_lib . (std synopsys std_cell_lib des_system_lib dw02
                           dw01 ramlib ieee))
    (dw01           . (ieee dw01 dware gtech))
    (dw02           . (ieee dw02 dware))
    (dw03           . (std synopsys dware dw03 dw02 dw01 ieee gtech))
    (dw04           . (dw04 ieee dw01 dware gtech))
    (dw05           . (dw05 ieee dware))
    (dw06           . (dw06 ieee dware))
    (dw07           . (ieee dware))
    (dware          . (ieee dware))
    (gtech          . (ieee gtech))
    (ramlib         . (std ieee))
    (std_cell_lib   . (ieee std_cell_lib))
    (synopsys       . ())))

(write (topological-sort example))


(define unsortable
  '((des_system_lib . (std synopsys std_cell_lib des_system_lib dw02
                           dw01 ramlib ieee))
    (dw01           . (ieee dw01 dware gtech dw04))
    (dw02           . (ieee dw02 dware))
    (dw03           . (std synopsys dware dw03 dw02 dw01 ieee gtech))
    (dw04           . (dw04 ieee dw01 dware gtech))
    (dw05           . (dw05 ieee dware))
    (dw06           . (dw06 ieee dware))
    (dw07           . (ieee dware))
    (dware          . (ieee dware))
    (gtech          . (ieee gtech))
    (ramlib         . (std ieee))
    (std_cell_lib   . (ieee std_cell_lib))
    (synopsys       . ())))

(newline)
(write (topological-sort unsortable))
