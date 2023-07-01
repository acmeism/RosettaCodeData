>>> for i in (False, True):
	for j in (False, True):
		print ("\nCalculating: x = a(i) and b(j) using x = b(j) if a(i) else False")
		x = b(j) if a(i) else False
		print ("Calculating: y = a(i) or  b(j) using y = b(j) if not a(i) else True")
		y = b(j) if not a(i) else True

		

Calculating: x = a(i) and b(j) using x = b(j) if a(i) else False
  # Called function a(False) -> False
Calculating: y = a(i) or  b(j) using y = b(j) if not a(i) else True
  # Called function a(False) -> False
  # Called function b(False) -> False

Calculating: x = a(i) and b(j) using x = b(j) if a(i) else False
  # Called function a(False) -> False
Calculating: y = a(i) or  b(j) using y = b(j) if not a(i) else True
  # Called function a(False) -> False
  # Called function b(True) -> True

Calculating: x = a(i) and b(j) using x = b(j) if a(i) else False
  # Called function a(True) -> True
  # Called function b(False) -> False
Calculating: y = a(i) or  b(j) using y = b(j) if not a(i) else True
  # Called function a(True) -> True

Calculating: x = a(i) and b(j) using x = b(j) if a(i) else False
  # Called function a(True) -> True
  # Called function b(True) -> True
Calculating: y = a(i) or  b(j) using y = b(j) if not a(i) else True
  # Called function a(True) -> True
