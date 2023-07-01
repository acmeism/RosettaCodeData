insert=:{{
  'R';'';y;a:
:
  if. 0=#y do. insert x
  elseif. 0=L.y do. x insert insert y
  else.
    'C e K w'=. y
    select. *x - K
      case. _1 do. balance C;(x insert e);K;<w
      case.  0 do. y
      case.  1 do. balance C;e;K;<x insert w
    end.
  end.
}}

NB. C: color, e: east, K: key, w: west
NB. two cascaded reds under a black become two black siblings under a red
balance=: {{
  'C e K w'=. y
  if. #e do.
    'eC ee eK ew'=. e
    if. 'R'=eC do.
      if. #ee do.
        'eeC eee eeK eew'=. ee NB. ((eee eeK eew) eK ew) K w   =>  (eee eeK eew) eK (ew K w)
        if. 'R'=eeC do. 'R';('B';eee;eeK;<eew);eK;<'B';ew;K;<w return. end. end.
      if. #ew do.
        'ewC ewe ewK eww'=. ew NB. (ee ek (ewe ewK eww)) K w  =>  (ee ek ewe) ewK (eww K w)
        if. 'R'=ewC do. 'R';('B';ee;eK;<ewe);ewK;<'B';eww;K;<w return. end. end. end. end.
  if. #w do.
    'wC we wK ww'=. w
    if. 'R'=wC do.
      if. #we do.
        'weC wee weK wew'=. we NB. e K ((wee weK wew) wK ww)  =>  (e K wee) weK (wew wK ww)
        if. 'R'=weC do. 'R';('B';e;K;<wee);weK;<'B';wew;wK;<ww return. end. end.
      if. #ww do.
        'wwC wwe wwK www'=. ww NB. e K (we wK (wwe wwK www))  =>  (e K we) wK (wwe wwK www)
        if. 'R'=wwC do. 'R';('B';e;K;<we);wK;<'B';wwe;wwK;<www return. end. end. end. end.
  y
}}
