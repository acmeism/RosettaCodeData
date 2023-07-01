var s = ""
for i in 1..10:
  s.add $i
  if i == 10: break
  s.add ", "
echo s
