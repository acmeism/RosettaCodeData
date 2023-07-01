Imports System.IO

  ' Loop through the lines of a file.
  ' Function assumes that the file exists.
  Private Sub ReadLines(ByVal FileName As String)

    Dim oReader As New StreamReader(FileName)
    Dim sLine As String = Nothing

    While Not oReader.EndOfStream
      sLine = oReader.ReadLine()
      ' Do something with the line.
    End While

    oReader.Close()

  End Sub
