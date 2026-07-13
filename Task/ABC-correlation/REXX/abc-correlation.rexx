/* Rexx */
-- .o....0....o....0....o....0....o....0....o....0
-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
--main:
  str. = ‘’
  _c = str.0 + 1; str.0 = _c; str._c = 'abacab'
  _c = str.0 + 1; str.0 = _c; str._c = 'abacab cbc'
  _c = str.0 + 1; str.0 = _c; str._c = 'internet'

  do _x = 1 to str.0
    say right((''''str._x''''), 20) ':' isABC(str._x)
  end _x

exit
-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
isABC: procedure
  parse arg occ
  occ = lower(occ)
  ayys = countstr('a', occ)
  bees = countstr('b', occ)
  cees = countstr('c', occ)

  return (ayys == bees & bees == cees)
