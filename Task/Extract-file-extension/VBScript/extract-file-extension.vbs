Function fileExt(fname)
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set regex = new regExp
        Dim ret

	regex.pattern = "^[A-Za-z0-9]+$"	'Only alphanumeric characters are allowed
	If regex.test(fso.GetExtensionName(fname)) = False Then
		ret = ""
	Else
		ret = "." & fso.GetExtensionName(fname)
	End If
	fileExt = ret
End Function

'Real Start of Program
arr_t = Array("http://example.com/download.tar.gz",	_
	      "CharacterModel.3DS",			_
	      ".desktop",				_
	      "document",				_
	      "document.txt_backup",			_
	      "/etc/pam.d/login")

For Each name In arr_t
	Wscript.Echo "NAME:",name
	Wscript.Echo " EXT:","<" & fileExt(name) & ">"
Next
