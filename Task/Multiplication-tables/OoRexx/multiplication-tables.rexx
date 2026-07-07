#!/usr/bin/env rexx
/* Rexx */
-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5

bxh = 'E2 94 80'x -- U+2500 horizontal
bxv = 'E2 94 82'x -- U+2502 vertical
bxt = 'E2 94 AC'x -- U+252C down tee
bxx = 'E2 94 BC'x -- U+253C cross
bxu = 'E2 94 B4'x -- U+2534 up tee

-— program argument sets max. bound of table. Defaults to 12
parse arg base .
if base~length = 0 then
  base = 12

a_base = .Array~new(base)
say 'tables 1 to' a_base~size

loop _x = 1 to a_base~size
  a_base[_x] = _x
end _x

say bxh~copies(5) || bxt || bxh~copies(base * 4 + 2)
say '+'~right(4) bxv fmtString(a_base)
say bxh~copies(5) || bxx || bxh~copies(base * 4 + 2)

loop _x = 1 to base
  ax = a_base~makearray

  loop _v = ax~size to 1 by -1
    if _v <= _x then do
      ax[_v] = ax[_v] * _x
    end
    else do
      ax~delete(_v)
    end
  end _v
  say _x~right(4) bxv fmtString(ax)
end _x
say bxh~copies(5) || bxu || bxh~copies(base * 4 + 2)
say

exit

-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
fmtString: procedure
  use arg strng

  fmt_str = ''
  loop itm over strng
    fmt_str = fmt_str || itm~right(4)
  end itm

  return fmt_str~strip('t')

exit

-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
