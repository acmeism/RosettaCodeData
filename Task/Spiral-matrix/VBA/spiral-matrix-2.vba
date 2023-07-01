Sub spiral(n As Integer)
  Const FREE = -9        'negative number indicates unoccupied cell
  Dim A() As Integer
  Dim rowdelta(3) As Integer
  Dim coldelta(3) As Integer

  'initialize A to a matrix with an extra "border" of occupied cells
  'this avoids having to test if we've reached the edge of the matrix

  ReDim A(0 To n + 1, 0 To n + 1)

  'Since A is initialized with zeros, setting A(1 to n,1 to n) to "FREE"
  'leaves a "border" around it occupied with zeroes

  For i = 1 To n: For j = 1 To n: A(i, j) = FREE: Next: Next

  'set amount to move in directions "right", "down", "left", "up"

  rowdelta(0) = 0: coldelta(0) = 1
  rowdelta(1) = 1: coldelta(1) = 0
  rowdelta(2) = 0: coldelta(2) = -1
  rowdelta(3) = -1: coldelta(3) = 0

  curnum = 0

  'set current cell position
  col = 1
  row = 1

  'set current direction
  theDir = 0  'theDir = 1 will fill the matrix counterclockwise

  'ok will be true as long as there is a free cell left
  ok = True

  Do While ok

     'occupy current FREE cell and increase curnum
      A(row, col) = curnum
      curnum = curnum + 1

      'check if next cell in current direction is free
      'if not, try another direction in clockwise fashion
      'if all directions lead to occupied cells then we are finished!

      ok = False
      For i = 0 To 3
        newdir = (theDir + i) Mod 4
        If A(row + rowdelta(newdir), col + coldelta(newdir)) = FREE Then
          'yes, move to it and change direction if necessary
          theDir = newdir
          row = row + rowdelta(theDir)
          col = col + coldelta(theDir)
          ok = True
          Exit For
        End If
      Next i
  Loop

  'print result
  For i = 1 To n
    For j = 1 To n
      Debug.Print A(i, j),
    Next
    Debug.Print
  Next

End Sub
