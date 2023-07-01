Imports System.Drawing.Imaging

  Public Function Grayscale(ByVal Map As Bitmap) As Bitmap

    Dim oData() As Integer = GetData(Map)
    Dim oReturn As New Bitmap(Map.Width, Map.Height, Map.PixelFormat)
    Dim a As Integer = 0
    Dim r As Integer = 0
    Dim g As Integer = 0
    Dim b As Integer = 0
    Dim l As Integer = 0

    For i As Integer = 0 To oData.GetUpperBound(0)
      a = (oData(i) >> 24)
      r = (oData(i) >> 16) And 255
      g = (oData(i) >> 8) And 255
      b = oData(i) And 255

      l = CInt(r * 0.2126F + g * 0.7152F + b * 0.0722F)

      oData(i) = (a << 24) Or (l << 16) Or (l << 8) Or l
    Next

    SetData(oReturn, oData)

    Return oReturn

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
