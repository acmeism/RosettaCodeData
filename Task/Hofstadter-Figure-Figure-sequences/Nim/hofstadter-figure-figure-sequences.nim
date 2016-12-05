var cr = @[1]
var cs = @[2]

proc extendRS =
  let x = cr[cr.high] + cs[cr.high]
  cr.add x
  for y in cs[cs.high] + 1 .. <x: cs.add y
  cs.add x + 1

proc ffr(n): int =
  assert n > 0
  while n > cr.len: extendRS()
  cr[n - 1]

proc ffs(n): int =
  assert n > 0
  while n > cs.len: extendRS()
  cs[n - 1]

for i in 1..10: stdout.write ffr i," "
echo ""

var bin: array[1..1000, int]
for i in 1..40: inc bin[ffr i]
for i in 1..960: inc bin[ffs i]
var all = true
for x in bin:
  if x != 1:
    all = false
    break

if all: echo "All Integers 1..1000 found OK"
else: echo "All Integers 1..1000 NOT found only once: ERROR"
