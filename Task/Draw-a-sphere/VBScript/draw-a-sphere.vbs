shades = Array(".", ":", "!", "*", "o", "e", "&", "#", "%", "@")
light = Array(30, 30, -50)

Sub Normalize(v)
   length = Sqr(v(0)*v(0) + v(1)*v(1) + v(2)*v(2))
   v(0) = v(0)/length : v(1) = v(1)/length : v(2) = v(2)/length
End Sub

Function Dot(x, y)
   d = x(0)*y(0) + x(1)*y(1) + x(2)*y(2)
   If d < 0 Then Dot = -d Else Dot = 0 End If
End Function

'floor function is the Int function
'ceil function implementation
Function Ceil(x)
    Ceil = Int(x)
    If Ceil <> x Then Ceil = Ceil + 1 End if
End Function

Sub DrawSphere(R, k, ambient)
   Dim i, j, intensity, inten, b, x, y
   Dim vec(3)
   For i = Int(-R) to Ceil(R)
      x = i + 0.5
      line = ""
      For j = Int(-2*R) to Ceil(2*R)
         y = j / 2 + 0.5
         If x * x + y * y <= R*R Then
            vec(0) = x
            vec(1) = y
            vec(2) = Sqr(R * R - x * x - y * y)
            Normalize vec
            b = dot(light, vec)^k + ambient
            intensity = Int((1 - b) * UBound(shades))
            If intensity < 0 Then intensity = 0 End If
            If intensity >= UBound(shades) Then
               intensity = UBound(shades)
            End If
            line = line & shades(intensity)
         Else
            line = line & " "
         End If
      Next
      WScript.StdOut.WriteLine line
   Next
End Sub

Normalize light
DrawSphere 20, 4, 0.1
DrawSphere 10,2,0.4
