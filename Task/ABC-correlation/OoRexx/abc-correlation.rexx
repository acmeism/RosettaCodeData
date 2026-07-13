#!/usr/bin/env rexx
/* Rexx */
—- .o....0....o....0....o....0....o....0....o....0
-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
--main:
  an_ABC = .ABC~new
  str. = 0
  _c = str.0 + 1; str.0 = _c; str._c = 'abacab'
  _c = str.0 + 1; str.0 = _c; str._c = 'abacab cbc'
  _c = str.0 + 1; str.0 = _c; str._c = 'internet'

  loop _x = 1 to str.0
    say (''''str._x'''')~right(20) ':' an_ABC~isABC(str._x)
  end _x

-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
::class ABC

::method isABC
  use arg occ
  occ = occ~lower
  ayys = occ~countstr('a')
  bees = occ~countstr('b')
  cees = occ~countstr('c')

  return (ayys == bees & bees == cees)
