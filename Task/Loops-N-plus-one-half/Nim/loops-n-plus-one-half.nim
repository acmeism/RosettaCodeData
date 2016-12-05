var s = ""

for i in 1..10:
  if s.len > 0: s.add(", ")
  s.add($i)

echo s
