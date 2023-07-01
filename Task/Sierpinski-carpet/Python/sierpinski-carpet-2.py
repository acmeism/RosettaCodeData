def sierpinski_carpet(n):
  carpet = ["#"]
  for i in xrange(n):
    carpet = [x + x + x for x in carpet] + \
             [x + x.replace("#"," ") + x for x in carpet] + \
             [x + x + x for x in carpet]
  return "\n".join(carpet)

print sierpinski_carpet(3)
