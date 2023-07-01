|=  [a=(list @sd) b=(list @sd)]
  =|  sum=@sd
  |-
  ?:  |(?=(~ a) ?=(~ b))  sum
  $(a t.a, b t.b, sum (sum:si sum (pro:si i.a i.b)))
