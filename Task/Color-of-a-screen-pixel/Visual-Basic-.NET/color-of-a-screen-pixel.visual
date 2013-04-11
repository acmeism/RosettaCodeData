  Private Function GetPixelColor(ByVal Location As Point) As Color

    Dim b As New Bitmap(1, 1)
    Dim g As Graphics = Graphics.FromImage(b)

    g.CopyFromScreen(Location, Point.Empty, New Size(1, 1))

    Return b.GetPixel(0, 0)

  End Function
