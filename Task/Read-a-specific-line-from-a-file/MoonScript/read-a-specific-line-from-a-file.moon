iter = io.lines 'test.txt'
for i=0, 5
  error 'Not 7 lines in file' if not iter!

print iter!
