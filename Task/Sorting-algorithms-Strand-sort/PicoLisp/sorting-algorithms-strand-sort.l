(de strandSort (Lst)
   (let Res NIL  # Result list
      (while Lst
         (let Sub (circ (car Lst))  # Build sublist as fifo
            (setq
               Lst (filter
                  '((X)
                     (or
                        (> (car Sub) X)
                        (nil (fifo 'Sub X)) ) )
                  (cdr Lst) )
               Res (make
                  (while (or Res Sub)  # Merge
                     (link
                        (if2 Res Sub
                           (if (>= (car Res) (cadr Sub))
                              (fifo 'Sub)
                              (pop 'Res) )
                           (pop 'Res)
                           (fifo 'Sub) ) ) ) ) ) ) )
      Res ) )
