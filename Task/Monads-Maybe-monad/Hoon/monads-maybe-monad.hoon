:-  %say
|=  [^ [[txt=(unit ,@tas) ~] ~]]
:-  %noun
|^
  %+  biff  txt
    ;~  biff
      m-parse
      m-double
    ==
  ++  m-parse
    |=  a=@tas
    ^-  (unit ,@ud)
    (rust (trip a) dem)
  ::
  ++  m-double
    |=  a=@ud
    ^-  (unit ,@ud)
    (some (mul a 2))
  --
