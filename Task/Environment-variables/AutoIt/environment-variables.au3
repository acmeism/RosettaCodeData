ConsoleWrite("# Environment:" & @CRLF)

Local $sEnvVar = EnvGet("LANG")
ConsoleWrite("LANG : " & $sEnvVar & @CRLF)

ShowEnv("SystemDrive")
ShowEnv("USERNAME")

Func ShowEnv($N)
    ConsoleWrite( StringFormat("%-12s : %s\n", $N, EnvGet($N)) )
EndFunc   ;==>ShowEnv
