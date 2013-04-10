(de bottles (N)
   (case N
      (0 "No more beer")
      (1 "One bottle of beer")
      (T (cons N " bottles of beer")) ) )

(for (N 99 (gt0 N))
   (prinl (bottles N) " on the wall,")
   (prinl (bottles N) ".")
   (prinl "Take one down, pass it around,")
   (prinl (bottles (dec 'N)) " on the wall.")
   (prinl) )
