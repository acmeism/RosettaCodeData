import posix

var p: array[2, cint]
discard pipe p
if fork() > 0:
  discard close p[0]
  discard sleep 1
  discard p[1].write(addr p[0], 1)
  var x: cint = 0
  discard wait x
else:
  discard close p[1]
  discard p[0].read(addr p[1], 1)
  echo "received signal from pipe"
