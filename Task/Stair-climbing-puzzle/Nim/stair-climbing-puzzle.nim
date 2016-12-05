proc stepUp1 =
  var deficit = 1
  while deficit > 0:
    if step():
      dec deficit
    else:
      inc deficit

proc stepUp2 =
  while not step():
    stepUp2()
