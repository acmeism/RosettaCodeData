|%
  ++  enc
    |=  [msg=tape key=@ud]
    ^-  tape
    (turn `(list @)`msg |=(n=@ud (add (mod (add (sub n 'A') key) 26) 'A')))
  ++  dec
    |=  [msg=tape key=@ud]
    (enc msg (sub 26 key))
  --
