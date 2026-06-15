/* Rexx */
-- . ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5
  sample = "abracadabra"
  check  = "AErBcadCbFD"

  !. = ''
  parse value 'A B a C D E r F' with !.a1 !.a2 !.a3 !.a4 !.a5 !.b1 !.r1 !.r2

  parse var sample p1 'a' p2 'a' p3 'a' p4 'a' p5 'a' p6
  target = p1 || !.a1 || p2 || !.a2 || p3 || !.a3 || p4 || !.a4 || p5  || !.a5 || p6

  parse var target q1 'b' q2
  target = q1 || !.b1 || q2

  parse var target o1 'r' o2 'r' o3
  target = o1 || !.r1 || o2 || !.r2 || o3

  say ' ' sample
  say ' ' target

  if compare(target, check) = 0 then
    say '  Success!'
  say

  return
