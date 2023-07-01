:-  %say
|=  *
:-  %noun
=/  i  .~2
=/  e  .~1
=/  e0  .~0
=/  denom  .~1
|-
?:  (lth:rd (sub:rd e e0) .~1e-15)
  e
%=  $
  i      (add:rd i .~1)
  e      (add:rd e (div:rd .~1 denom))
  e0     e
  denom  (mul:rd denom i)
==
