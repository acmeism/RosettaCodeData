for objItem in ComObjGet("winmgmts:\\.\root\CIMV2").ExecQuery("SELECT * FROM Win32_ComputerSystem")
    MsgBox, % "Hostname:`t" objItem.Name
