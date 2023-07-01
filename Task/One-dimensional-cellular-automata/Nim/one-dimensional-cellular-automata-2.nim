import strutils

const
  s_init: string = "_###_##_#_#_#_#__#__"
  arrLen: int = 20

var q0: string = s_init & repeat('_',arrLen-20)
var q1: string = q0

proc life(s:string): char =
   var str: string = s
   if len(normalize(str)) == 2:      # normalize eliminates underscores
      return '#'
   return '_'

proc evolve(q: string): string =
   result = repeat('_',arrLen)
   #result[0] = '_'
   for i in 1 .. q.len-1:
      result[i] = life(substr(q & '_',i-1,i+1))

echo(q1)
q1 = evolve(q0)
echo(q1)
while q1 != q0:
   q0 = q1
   q1 = evolve(q0)
   echo(q1)
