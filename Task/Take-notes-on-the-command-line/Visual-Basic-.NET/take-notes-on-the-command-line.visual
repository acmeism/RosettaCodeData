Imports System.IO

Module Notes
    Function Main(ByVal cmdArgs() As String) As Integer
        Try
            If cmdArgs.Length = 0 Then
                Using sr As New StreamReader("NOTES.TXT")
                    Console.WriteLine(sr.ReadToEnd)
                End Using
            Else
                Using sw As New StreamWriter("NOTES.TXT", True)
                    sw.WriteLine(Date.Now.ToString())
                    sw.WriteLine("{0}{1}", ControlChars.Tab, String.Join(" ", cmdArgs))
                End Using
            End If
        Catch
        End Try
    End Function
End Module
