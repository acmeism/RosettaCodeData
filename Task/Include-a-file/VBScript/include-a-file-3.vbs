Include "%INCLUDE%\StrFuncs.vbs"

Function Include ( ByVal file )
    Dim wso: Set wso = CreateObject("Wscript.Shell")
    Dim fso: Set fso = CreateObject("Scripting.FileSystemObject")
    ExecuteGlobal(fso.OpenTextFile(wso.ExpandEnvironmentStrings(file)).ReadAll)
End Function
