For Each line In ExecCmd("ipconfig /all")
    Wscript.Echo line
Next

'Execute the given command and return the output in a text array.
Function ExecCmd(cmd)

    'Execute the command
    Dim wso : Set wso = CreateObject("Wscript.Shell")
    Dim exec : Set exec = wso.Exec(cmd)
    Dim res : res = ""

    'Read all result text from standard output
    Do
        res = res & VbLf & exec.StdOut.ReadLine
    Loop Until exec.StdOut.AtEndOfStream

    'Return as a text array
    ExecCmd = Split(Mid(res,2),vbLf)
End Function
