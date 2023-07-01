(de rotw (W)
   (let W (chop W)
      (unless (or (apply = W) (not (cddr W)))
         (make
            (do (length W)
               (link (pack (copy W)))
               (rot W) ) ) ) ) )
(off D)
(put 'D 'v (cons))
(mapc
   '((W)
      (idx 'D (cons (hash W) W) T) )
   (setq Words
      (make (in "wordlist.10000" (while (line T) (link @)))) ) )
(mapc
   println
   (extract
      '((W)
         (let? Lst (rotw W)
            (when
               (and
                  (fully
                     '((L) (idx 'D (cons (hash L) L)))
                     Lst )
                  (not
                     (member (car Lst) (car (get 'D 'v))) ) )
               (mapc
                  '((L) (push (get 'D 'v) L))
                  Lst )
               Lst ) ) )
      Words ) )
