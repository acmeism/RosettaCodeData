>>> def a(answer):
	print("  # Called function a(%r) -> %r" % (answer, answer))
	return answer

>>> def b(answer):
	print("  # Called function b(%r) -> %r" % (answer, answer))
	return answer

>>> for i in (False, True):
	for j in (False, True):
		print ("\nCalculating: x = a(i) and b(j)")
		x = a(i) and b(j)
		print ("Calculating: y = a(i) or  b(j)")
		y = a(i) or  b(j)

		

Calculating: x = a(i) and b(j)
  # Called function a(False) -> False
Calculating: y = a(i) or  b(j)
  # Called function a(False) -> False
  # Called function b(False) -> False

Calculating: x = a(i) and b(j)
  # Called function a(False) -> False
Calculating: y = a(i) or  b(j)
  # Called function a(False) -> False
  # Called function b(True) -> True

Calculating: x = a(i) and b(j)
  # Called function a(True) -> True
  # Called function b(False) -> False
Calculating: y = a(i) or  b(j)
  # Called function a(True) -> True

Calculating: x = a(i) and b(j)
  # Called function a(True) -> True
  # Called function b(True) -> True
Calculating: y = a(i) or  b(j)
  # Called function a(True) -> True
