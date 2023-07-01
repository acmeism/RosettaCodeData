(max 1 2 3 4)
(reduce #'max values) ; find max of a list
(loop for x in values
      maximize x) ; alternative way to find max of a list
