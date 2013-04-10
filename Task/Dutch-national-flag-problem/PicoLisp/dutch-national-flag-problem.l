(def 'Colors
   (list
      (def 'RED 1)
      (def 'WHITE 2)
      (def 'BLUE 3) ) )

(let (L (make (do 9 (link (get Colors (rand 1 3)))))  S (by val sort L))
   (prin "Original balls ")
   (print L)
   (prinl (unless (= L S) " not sorted"))
   (prin "Sorted balls   ")
   (print S)
   (prinl " are sorted") )
