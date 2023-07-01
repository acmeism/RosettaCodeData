(de streamMerge @
   (let Heap
      (make
         (while (args)
            (let? Fd (next)
               (if (in Fd (read))
                  (link (cons @ Fd))
                  (close Fd) ) ) ) )
      (make
         (while Heap
            (link (caar (setq Heap (sort Heap))))
            (if (in (cdar Heap) (read))
               (set (car Heap) @)
               (close (cdr (pop 'Heap))) ) ) ) ) )
