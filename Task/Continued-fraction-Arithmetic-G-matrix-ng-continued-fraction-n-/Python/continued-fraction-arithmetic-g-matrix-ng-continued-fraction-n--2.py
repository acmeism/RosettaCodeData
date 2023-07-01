data = [["[1;5,2] + 1/2",      [2,1,0,2], [13,11]],
        ["[3;7] + 1/2",        [2,1,0,2], [22, 7]],
        ["[3;7] divided by 4", [1,0,0,4], [22, 7]]]

for string, ng, r in data:
  print( "%-20s->" % string, end='' )
  op = NG(*ng)
  for n in r2cf(*r):
    if not op.needterm: print( " %r" % op.egress, end='' )
    op.ingress(n)
  while True:
    print( " %r" % op.egress_done, end='' )
    if op.done: break
  print()
