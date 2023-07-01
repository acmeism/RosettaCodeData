(test (2 3 14 15 17 18)
   (streamMerge
      (open "a")
      (open "b") ) )

(test (2 2 3 3 5 7 14 15 17 18)
   (streamMerge
      (open "a")
      (open "b")
      (open "c")
      (open "d") ) )
