'Purpose: Converts TXT files into VBS code with a function that returns a text string with the contents of the TXT file
'		  The TXT file can even be another VBS file.

'History:
'	1.0	8may2009	Initial release
'
'
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
Const TristateUseDefault = -2

set WshShell = CreateObject("WSCript.shell")

'File browse dialog box
Set objDialog = CreateObject("UserAccounts.CommonDialog")
objDialog.Filter = "All Files|*.*"
objDialog.InitialDir = WshShell.CurrentDirectory
intResult = objDialog.ShowOpen

If intResult = 0 Then
	WshShell.Popup "No file selected.", 2, " ", 64
    Wscript.Quit
Else
    strFileNameIN = objDialog.FileName
End If

strFileNameOUT= strFileNameIN & "_CONVERTED.Vbs"

'Check if strFileNameOUT exists already
Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists(strFileNameOUT) then  'does the file EXIST?
'	WScript.Echo "found"
	OVRWT=MSGBOX(strFileNameOUT & " exists already"&vbCRLF&"Overwrite?",vbYesNoCancel,"Overwrite?")
	if OVRWT = 6 then
		'proceed
		objFSO.DeleteFile(strFileNameOUT)
	else
		WshShell.Popup "Exiting as requested.", 1, " ", 64
		Wscript.Quit
	End If
Else
'	WScript.Echo "not found" 'strFileNameOUT does NOT exists already
	
END if

strBaseName=objFSO.GetBaseName(strFileNameIN)


'open strFileNameANSI file, and put entire file into a variable ****SIZE LIMIT ??*****
Set objFile = objFSO.OpenTextFile(strFileNameIN, ForReading)
strText = objFile.ReadAll
objFile.Close

'Start converting

'Convert " to ""
strOldText = Chr(34)
strNewText = Chr(34)&Chr(34)
strText = Replace(strText, strOldText, strNewText)

'Add objTXTFile.writeline ("
strOldText = VBCRLF
strNewText = """)  &vbCrLf"&VBCRLF&"	strText=strText& ("""
strText = Replace(strText, strOldText, strNewText)
'Converting done

strFileName=objFSO.GetFileName(strFileNameIN)

'Write to file
Set objFile = objFSO.OpenTextFile(strFileNameOUT, ForAppending, True)
objFile.WriteLine "'this Function will return a string containing the contents of the file called "&strFileName
objFile.WriteLine "msgbox "&strBaseName &"()"
objFile.WriteLine vbCrLf
objFile.WriteLine "Function "&strBaseName&"()"
objFile.WriteLine "	'returns a string containing the contents of the file called "&strFileName
objFile.WriteLine "	Dim strText"
objFile.WriteLine "	strText= ("""&strText&""") &vbCrLf"
objFile.WriteLine "	"&strBaseName&"=strText"
objFile.WriteLine "End Function"
objFile.Close

WshShell.Popup "created " & strFileNameOUT, 3, "Completed", 64
