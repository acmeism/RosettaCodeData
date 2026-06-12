Imports System.Drawing

Module Module1

    Function Lerp(s As Single, e As Single, t As Single) As Single
        Return s + (e - s) * t
    End Function

    Function Blerp(c00 As Single, c10 As Single, c01 As Single, c11 As Single, tx As Single, ty As Single) As Single
        Return Lerp(Lerp(c00, c10, tx), Lerp(c01, c11, tx), ty)
    End Function

    Function Scale(self As Bitmap, scaleX As Single, scaleY As Single) As Image
        Dim newWidth = CInt(Math.Floor(self.Width * scaleX))
        Dim newHeight = CInt(Math.Floor(self.Height * scaleY))
        Dim newImage As New Bitmap(newWidth, newHeight, self.PixelFormat)

        For x = 0 To newWidth - 1
            For y = 0 To newHeight - 1
                Dim gx = CSng(x) / newWidth * (self.Width - 1)
                Dim gy = CSng(y) / newHeight * (self.Height - 1)
                Dim gxi = CInt(Math.Floor(gx))
                Dim gyi = CInt(Math.Floor(gy))
                Dim c00 = self.GetPixel(gxi, gyi)
                Dim c10 = self.GetPixel(gxi + 1, gyi)
                Dim c01 = self.GetPixel(gxi, gyi + 1)
                Dim c11 = self.GetPixel(gxi + 1, gyi + 1)

                Dim red = CInt(Blerp(c00.R, c10.R, c01.R, c11.R, gx - gxi, gy - gyi))
                Dim green = CInt(Blerp(c00.G, c10.G, c01.G, c11.G, gx - gxi, gy - gyi))
                Dim blue = CInt(Blerp(c00.B, c10.B, c01.B, c11.B, gx - gxi, gy - gyi))
                Dim rgb = Color.FromArgb(red, green, blue)

                newImage.SetPixel(x, y, rgb)
            Next
        Next

        Return newImage
    End Function

    Sub Main()
        Dim newImage = Image.FromFile("Lenna100.jpg")
        If TypeOf newImage Is Bitmap Then
            Dim oi As Bitmap = newImage
            Dim result = Scale(oi, 1.6, 1.6)
            result.Save("Lenna100_larger.jpg")
        Else
            Console.WriteLine("Could not open the source file.")
        End If
    End Sub

End Module
