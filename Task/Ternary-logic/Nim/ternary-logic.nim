type Trit* = enum ttrue, tmaybe, tfalse

proc `$`*(a: Trit): string =
  case a
  of ttrue: "T"
  of tmaybe: "?"
  of tfalse: "F"

proc `not`*(a: Trit): Trit =
  case a
  of ttrue: tfalse
  of tmaybe: tmaybe
  of tfalse: ttrue

proc `and`*(a, b: Trit): Trit =
  const t: array[Trit, array[Trit, Trit]] =
    [ [ttrue,  tmaybe, tfalse]
    , [tmaybe, tmaybe, tfalse]
    , [tfalse, tfalse, tfalse] ]
  t[a][b]

proc `or`*(a, b: Trit): Trit =
  const t: array[Trit, array[Trit, Trit]] =
    [ [ttrue, ttrue,  ttrue]
    , [ttrue, tmaybe, tmaybe]
    , [ttrue, tmaybe, tfalse] ]
  t[a][b]

proc then*(a, b: Trit): Trit =
  const t: array[Trit, array[Trit, Trit]] =
    [ [ttrue, tmaybe, tfalse]
    , [ttrue, tmaybe, tmaybe]
    , [ttrue, ttrue,  ttrue] ]
  t[a][b]

proc equiv*(a, b: Trit): Trit =
  const t: array[Trit, array[Trit, Trit]] =
    [ [ttrue,  tmaybe, tfalse]
    , [tmaybe, tmaybe, tmaybe]
    , [tfalse, tmaybe, ttrue] ]
  t[a][b]

import strutils

var
  op1 = ttrue
  op2 = ttrue

for t in Trit:
  echo "Not ", t , ": ", not t

for op1 in Trit:
  for op2 in Trit:
    echo "$# and   $#: $#".format(op1, op2, op1 and op2)
    echo "$# or    $#: $#".format(op1, op2, op1 or op2)
    echo "$# then  $#: $#".format(op1, op2, op1.then op2)
    echo "$# equiv $#: $#".format(op1, op2, op1.equiv op2)
