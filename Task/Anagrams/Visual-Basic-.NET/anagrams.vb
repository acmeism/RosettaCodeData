Imports System.IO
Imports System.Collections.ObjectModel

Module Module1

  Dim sWords As New Dictionary(Of String, Collection(Of String))

  Sub Main()

    Dim oStream As StreamReader = Nothing
    Dim sLines() As String = Nothing
    Dim sSorted As String = Nothing
    Dim iHighCount As Integer = 0
    Dim iMaxKeyLength As Integer = 0
    Dim sOutput As String = ""

    oStream = New StreamReader("unixdict.txt")
    sLines = oStream.ReadToEnd.Split(New String() {vbCrLf}, StringSplitOptions.RemoveEmptyEntries)
    oStream.Close()

    For i As Integer = 0 To sLines.GetUpperBound(0)
      sSorted = SortCharacters(sLines(i))

      If Not sWords.ContainsKey(sSorted) Then sWords.Add(sSorted, New Collection(Of String))

      sWords(sSorted).Add(sLines(i))

      If sWords(sSorted).Count > iHighCount Then
        iHighCount = sWords(sSorted).Count

        If sSorted.Length > iMaxKeyLength Then iMaxKeyLength = sSorted.Length
      End If
    Next

    For Each sKey As String In sWords.Keys
      If sWords(sKey).Count = iHighCount Then
        sOutput &= "[" & sKey.ToUpper & "]" & Space(iMaxKeyLength - sKey.Length + 1) & String.Join(", ", sWords(sKey).ToArray()) & vbCrLf
      End If
    Next

    Console.WriteLine(sOutput)
    Console.ReadKey()

  End Sub

  Private Function SortCharacters(ByVal s As String) As String

    Dim sReturn() As Char = s.ToCharArray()
    Dim sTemp As Char = Nothing

    For i As Integer = 0 To sReturn.GetUpperBound(0) - 1
      If (sReturn(i + 1)) < (sReturn(i)) Then
        sTemp = sReturn(i)
        sReturn(i) = sReturn(i + 1)
        sReturn(i + 1) = sTemp
        i = -1
      End If
    Next

    Return CStr(sReturn)

  End Function

End Module
