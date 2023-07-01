Imports System.Drawing.Imaging

Public Class Form1

  ReadOnly iCanvasColor As Integer = Color.Black.ToArgb
  ReadOnly iSeedColor As Integer = Color.White.ToArgb

  Dim iCanvasWidth As Integer = 0
  Dim iCanvasHeight As Integer = 0

  Dim iPixels() As Integer = Nothing

  Private Sub BrownianTree()

    Dim oCanvas As Bitmap = Nothing
    Dim oRandom As New Random(Now.Millisecond)
    Dim oXY As Point = Nothing
    Dim iParticleCount As Integer = 0

    iCanvasWidth = ClientSize.Width
    iCanvasHeight = ClientSize.Height

    oCanvas = New Bitmap(iCanvasWidth, iCanvasHeight, Imaging.PixelFormat.Format24bppRgb)

    Graphics.FromImage(oCanvas).Clear(Color.FromArgb(iCanvasColor))

    iPixels = GetData(oCanvas)

    ' We'll use about 10% of the total number of pixels in the canvas for the particle count.
    iParticleCount = CInt(iPixels.Length * 0.1)

    ' Set the seed to a random location on the canvas.
    iPixels(oRandom.Next(iPixels.Length)) = iSeedColor

    ' Run through the particles.
    For i As Integer = 0 To iParticleCount
      Do
        ' Find an open pixel.
        oXY = New Point(oRandom.Next(oCanvas.Width), oRandom.Next(oCanvas.Height))
      Loop While iPixels(oXY.Y * oCanvas.Width + oXY.X) = iSeedColor

      ' Jitter until the pixel bumps another.
      While Not CheckAdjacency(oXY)
        oXY.X += oRandom.Next(-1, 2)
        oXY.Y += oRandom.Next(-1, 2)

        ' Make sure we don't jitter ourselves out of bounds.
        If oXY.X < 0 Then oXY.X = 0 Else If oXY.X >= oCanvas.Width Then oXY.X = oCanvas.Width - 1
        If oXY.Y < 0 Then oXY.Y = 0 Else If oXY.Y >= oCanvas.Height Then oXY.Y = oCanvas.Height - 1
      End While

      iPixels(oXY.Y * oCanvas.Width + oXY.X) = iSeedColor

      ' If you'd like to see updates as each particle collides and becomes
      ' part of the tree, uncomment the next 4 lines (it does slow it down slightly).
      ' SetData(oCanvas, iPixels)
      ' BackgroundImage = oCanvas
      ' Invalidate()
      ' Application.DoEvents()
    Next

    oCanvas.Save("BrownianTree.bmp")
    BackgroundImage = oCanvas

  End Sub

  ' Check adjacent pixels for an illuminated pixel.
  Private Function CheckAdjacency(ByVal XY As Point) As Boolean

    Dim n As Integer = 0

    For y As Integer = -1 To 1
      ' Make sure not to drop off the top or bottom of the image.
      If (XY.Y + y < 0) OrElse (XY.Y + y >= iCanvasHeight) Then Continue For

      For x As Integer = -1 To 1
        ' Make sure not to drop off the left or right of the image.
        If (XY.X + x < 0) OrElse (XY.X + x >= iCanvasWidth) Then Continue For

        ' Don't run the test on the calling pixel.
        If y <> 0 AndAlso x <> 0 Then
          n = (XY.Y + y) * iCanvasWidth + (XY.X + x)
          If iPixels(n) = iSeedColor Then Return True
        End If
      Next
    Next

    Return False

  End Function

  Private Function GetData(ByVal Map As Bitmap) As Integer()

    Dim oBMPData As BitmapData = Nothing
    Dim oData() As Integer = Nothing

    oBMPData = Map.LockBits(New Rectangle(0, 0, Map.Width, Map.Height), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb)

    Array.Resize(oData, Map.Width * Map.Height)

    Runtime.InteropServices.Marshal.Copy(oBMPData.Scan0, oData, 0, oData.Length)

    Map.UnlockBits(oBMPData)

    Return oData

  End Function

  Private Sub SetData(ByVal Map As Bitmap, ByVal Data As Integer())

    Dim oBMPData As BitmapData = Nothing

    oBMPData = Map.LockBits(New Rectangle(0, 0, Map.Width, Map.Height), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb)

    Runtime.InteropServices.Marshal.Copy(Data, 0, oBMPData.Scan0, Data.Length)

    Map.UnlockBits(oBMPData)

  End Sub

  Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
    DoubleBuffered = True
    BackgroundImageLayout = ImageLayout.Center
    Show()
    Activate()
    Application.DoEvents()
    BrownianTree()
  End Sub
End Class
