(de foo (N)
   (prinl "This is 'foo'")
   (printsp N)
   (or (=0 (dec 'N)) (run (cddr foo))) )
