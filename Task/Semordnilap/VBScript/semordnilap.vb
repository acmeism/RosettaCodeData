Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objInFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
    "\unixdict.txt",1)

Set objUnixDict = CreateObject("Scripting.Dictionary")
Set objSemordnilap = CreateObject("Scripting.Dictionary")

Do Until objInFile.AtEndOfStream
  line = objInFile.ReadLine
  If Len(line) > 1 Then
    objUnixDict.Add line,""
  End If
  reverse_line = StrReverse(line)
  If reverse_line <> line And objUnixDict.Exists(reverse_line) Then
    objSemordnilap.Add line, reverse_line
  End If
Loop

'Display the first 5 keys.
k = 0
For Each Key In objSemordnilap.Keys
  WScript.StdOut.Write Key & " - " & objSemordnilap.Item(Key)
  WScript.StdOut.WriteLine
  k = k + 1
  If k = 5 Then
    Exit For
  End If
Next

WScript.StdOut.Write "Total Count:  " & objSemordnilap.Count
WScript.StdOut.WriteLine

objInFile.Close
Set objFSO = Nothing
Set objUnixDict = Nothing
Set objSemordnilap = Nothing
