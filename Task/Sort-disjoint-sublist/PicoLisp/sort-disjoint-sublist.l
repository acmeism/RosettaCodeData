(let (Values (7 6 5 4 3 2 1 0)  Indices (7 2 8))
   (mapc
      '((V I) (set (nth Values I) V))
      (sort (mapcar '((N) (get Values N)) Indices))
      (sort Indices) )
   Values )
