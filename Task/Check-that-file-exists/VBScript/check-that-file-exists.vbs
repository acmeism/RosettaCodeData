Set FSO = CreateObject("Scripting.FileSystemObject")

Function FileExists(strFile)
    If FSO.FileExists(strFile) Then
        FileExists = True
    Else
        FileExists = False
    End If
End Function

Function FolderExists(strFolder)
    If FSO.FolderExists(strFolder) Then
        FolderExists = True
    Else
        Folderexists = False
    End If
End Function

'''''Usage (apostrophes indicate comments-this section will not be run)'''''
'If FileExists("C:\test.txt") Then
'   MsgBox "It Exists!"
'Else
'   Msgbox "awww"
'End If
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'Shorter version

If CreateObject("Scripting.FileSystemObject").FileExists("d:\test.txt") Then
    Wscript.Echo "File Exists"
Else
    Wscript.Echo "File Does Not Exist")
End If
