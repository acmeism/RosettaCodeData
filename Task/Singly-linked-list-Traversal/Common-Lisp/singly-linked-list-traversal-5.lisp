(loop for ref = list then (rest ref)
      until (null ref)
      do (print (first ref)))
