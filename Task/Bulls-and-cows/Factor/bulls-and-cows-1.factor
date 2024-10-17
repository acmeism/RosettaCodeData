USING: io kernel math math.parser random ranges sequences sets ; IN: bullsncows
9 [1..b] 4 sample [ 48 + ] "" map-as
[ "guess the 4-digit number: " write flush readln dup
  [ length 4 = ] [ [ 48 57 [a..b] in? ] all? ] bi and ! [48,57] is the ascii range for 0-9
  [ 2dup =
    [ 2drop "yep!" print flush f ]
    [ "bulls & cows: " write
      [ 0 [ = 1 0 ? + ] 2reduce ] [ intersect length ] 2bi over -
      [ number>string ] bi@ " & " glue print flush t ]
    if ]
  [ 2drop "bad input" print t ]
  if ] curry loop
