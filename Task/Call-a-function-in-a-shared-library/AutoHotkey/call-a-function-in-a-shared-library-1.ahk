ahkdll := DllCall("LoadLibrary", "str", "AutoHotkey.dll")
clientHandle := DllCall("AutoHotkey\ahkdll", "str", "dllclient.ahk", "str"
, "", "str", "parameter1 parameter2", "Cdecl Int")
