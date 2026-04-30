x = 6 : y = 2 : z = 3

Sub cuboid(nx, ny, nz)
   WScript.StdOut.WriteLine "Cuboid " & nx & " " & ny & " " & nz & ":"
   lx = X * nx : ly = y * ny : lz = z * nz

   'define the array
   Dim area(): ReDim area(ly+lz, lx+ly)
   For i = 0 to ly+lz
      For j = 0 to lx+ly : area(i,j) = " " : Next
   Next

   'drawing lines
   For i = 0 to nz-1 : drawLine area, lx,      0,    Z*i, "-" : Next
   For i = 0 to ny   : drawLine area, lx,    y*i, lz+y*i, "-" : Next
   For i = 0 to nx-1 : drawLine area, lz,    x*i,      0, "|" : Next
   For i = 0 to ny   : drawLine area, lz, lx+y*i,    y*i, "|" : Next
   For i = 0 to nz-1 : drawLine area, ly,     lx,    z*i, "/" : Next
   For i = 0 to nx   : drawLine area, ly,    x*i,     lz, "/" : Next

   'output the cuboid (in reverse)
   For i = UBound(area,1) to 0 Step -1
      linOut = ""
      For j = 0 to UBound(area,2) : linOut = linOut & area(i,j) : Next
      WScript.StdOut.WriteLine linOut
   Next
End Sub

Sub drawLine(arr, n, sx, sy, c)
   Select Case c
      Case "-"
         dx = 1 : dy = 0
      Case "|"
         dx = 0 : dy = 1
      Case "/"
         dx = 1 : dy = 1
   End Select
   For i = 0 to n
      xi = sx + (i * dx) : yi = sy + (i * dy)
      If arr(yi, xi) = " " Then
         arr(yi, xi) = c
      Else
         arr(yi, xi) = "+"
      End If
   Next
End Sub

cuboid 2,3,4
