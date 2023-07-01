|%
++  parse
  |=  t=tape  ^-  @ud
  =.  t  (cass t)
  =|  result=@ud
  |-
  ?~  t  result
  ?~  t.t  (add result (from-numeral i.t))
  =+  [a=(from-numeral i.t) b=(from-numeral i.t.t)]
  ?:  (gte a b)  $(result (add result a), t t.t)
  $(result (sub (add result b) a), t t.t.t)
++  yield
  |=  n=@ud  ^-  tape
  =|  result=tape
  =/  values  to-numeral
  |-
  ?~  values  result
  ?:  (gte n -.i.values)
    $(result (weld result +.i.values), n (sub n -.i.values))
  $(values t.values)
++  from-numeral
  |=  c=@t  ^-  @ud
  ?:  =(c 'i')  1
  ?:  =(c 'v')  5
  ?:  =(c 'x')  10
  ?:  =(c 'l')  50
  ?:  =(c 'c')  100
  ?:  =(c 'd')  500
  ?:  =(c 'm')  1.000
  !!
++  to-numeral
  ^-  (list [@ud tape])
  :*
    [1.000 "m"]
    [900 "cm"]
    [500 "d"]
    [400 "cd"]
    [100 "c"]
    [90 "xc"]
    [50 "l"]
    [40 "xl"]
    [10 "x"]
    [9 "ix"]
    [5 "v"]
    [4 "iv"]
    [1 "i"]
    ~
  ==
--
