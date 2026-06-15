/* Rexx */
-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
  sample = "abracadabra"
  ?.  = ''
  ?.0 = 8
  ?.1 = 'a A' -- 1st a
  ?.2 = 'a B' -- 2nd a
  ?.3 = 'a @' -- skip
  ?.4 = 'a C' -- 4th a
  ?.5 = 'a D' -- 5th a
  ?.6 = 'b E' -- 1st b
  ?.7 = 'r $' -- skip
  ?.8 = 'r F' -- 2nd r

  target = sample
  do ix = 1 to ?.0
    parse var ?.ix chs chn .
    loc = pos(chs, target)
    if loc <> 0 then
      target = overlay(chn, target, loc, 1)
  end ix
  target = translate(target, 'ar', '@$')

  check = "AErBcadCbFD"
  say ' ' sample
  say ' ' target
  if compare(target, check) = 0 then
    say '  Success!'
  say

  return
