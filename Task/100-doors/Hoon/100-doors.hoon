|^
=/  doors=(list ?)  (reap 100 %.n)
=/  passes=(list (list ?))  (turn (gulf 1 100) pass-n)
|-
?~  passes  doors
$(doors (toggle doors i.passes), passes t.passes)
++  pass-n
  |=  n=@ud
  (turn (gulf 1 100) |=(k=@ud =((mod k n) 0)))
++  toggle
  |=  [a=(list ?) b=(list ?)]
  =|  c=(list ?)
  |-
  ?:  |(?=(~ a) ?=(~ b))  (flop c)
  $(a t.a, b t.b, c [=((mix i.a i.b) 1) c])
--
