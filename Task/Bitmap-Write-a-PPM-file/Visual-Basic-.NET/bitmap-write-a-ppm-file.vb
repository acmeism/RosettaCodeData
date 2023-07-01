Public Shared Sub SaveRasterBitmapToPpmFile(ByVal rasterBitmap As RasterBitmap, ByVal filepath As String)
   Dim header As String = String.Format("P6{0}{1}{2}{3}{0}255{0}", vbLf, rasterBitmap.Width, " "c, rasterBitmap.Height)
   Dim bufferSize As Integer = header.Length + (rasterBitmap.Width * rasterBitmap.Height * 3)
   Dim bytes(bufferSize - 1) As Byte
   Buffer.BlockCopy(Encoding.ASCII.GetBytes(header.ToString), 0, bytes, 0, header.Length)
   Dim index As Integer = header.Length
   For y As Integer = 0 To rasterBitmap.Height - 1
      For x As Integer = 0 To rasterBitmap.Width - 1
         Dim color As Rgb = rasterBitmap.GetPixel(x, y)
         bytes(index) = color.R
         bytes(index + 1) = color.G
         bytes(index + 2) = color.B
         index += 3
      Next
   Next
   My.Computer.FileSystem.WriteAllBytes(filepath, bytes, False)
End Sub
