data[] = [ 85 88 75 66 25 29 83 39 97 68 41 10 49 16 65 32 92 28 98 ]
func pick at remain accu treat .
   if remain = 0 : return if accu > treat
   a = pick (at - 1) (remain - 1) (accu + data[at]) treat
   if at > remain : b = pick (at - 1) remain accu treat
   return a + b
.
proc main .
   total = 1
   for i to 9 : treat += data[i]
   for i = 19 downto 11 : total *= i
   for i = 9 downto 1 : total /= i
   gt = pick 19 9 0 treat
   le = total - gt
   print 100 * le / total & "% " & 100 * gt / total & "%"
.
main
