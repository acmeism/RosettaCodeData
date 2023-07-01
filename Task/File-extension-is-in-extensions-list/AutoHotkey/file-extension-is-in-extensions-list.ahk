fileList := "MyData.a##,MyData.tar.Gz,MyData.gzip,MyData.7z.backup,MyData...,MyData,MyData_v1.0.tar.bz2,MyData_v1.0.bz2"
extList := "zip,rar,7z,gz,archive,A##,tar.bz2"
textOut := "File extension is in list (" extList ") ?`n"
loop,parse,fileList,CSV
	{
		textOut .= A_LoopField " ---> "
		lastDotPos := InStr(A_LoopField,".",0,0)
		extloop := SubStr(A_LoopField,lastDotPos+1)
		if (extloop = "bz2")
			{
				lastDotPos := InStr(A_LoopField,".",0,0,2)
				extloop := SubStr(A_LoopField,lastDotPos+1)
			}
		if !lastDotPos or !extloop
			textOut .= "NO`n"
		else if extloop in %extList%
			textOut .= "YES`n"
		else
			textOut .= "NO`n"
	}
 MsgBox % textOut
 ExitApp
