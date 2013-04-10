(let Words NIL
   (in "unixdict.txt"
      (while (line)
         (let (Word @  Key (pack (sort (copy @))))
            (if (idx 'Words Key T)
               (push (car @) Word)
               (set Key (list Word)) ) ) ) )
   (maxi '((X) (length (car X)))
      (extract
         '((Key)
            (pick
               '((Lst)
                  (and
                     (find
                        '((L) (not (find = L Lst)))
                        (val Key) )
                     (cons (pack @) (pack Lst)) ) )
               (val Key) ) )
         (idx 'Words) ) ) )
