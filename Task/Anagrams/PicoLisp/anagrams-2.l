(let Words NIL
   (in "unixdict.txt"
      (while (line)
         (let (Word (pack @)  Key (pack (sort @)))
            (if (idx 'Words Key T)
               (push (car @) Word)
               (set Key (list Word)) ) ) ) )
   (flip (by length sort (mapcar val (idx 'Words)))) )
