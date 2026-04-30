Set objConn = CreateObject("ADODB.Connection")
Set objCmd = CreateObject("ADODB.Command")
objConn.Provider = "ADsDSOObject"
objConn.Open
