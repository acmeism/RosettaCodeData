(de makeList (Sep)
   (let (Cnt 0  makeItem '((Str) (prinl (inc 'Cnt) Sep Str)))
      (makeItem "first")
      (makeItem "second")
      (makeItem "third") ) )

(makeList ". ")
