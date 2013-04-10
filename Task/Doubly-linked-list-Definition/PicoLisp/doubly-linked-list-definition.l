# Build a doubly-linked list
(de 2list @
   (let Prev NIL
      (let L
         (make
            (while (args)
               (setq Prev (chain (list (next) Prev))) ) )
         (cons L Prev) ) ) )

(setq *DLst (2list 'was 'it 'a 'cat 'I 'saw))
