#Persistent
CLSID_ThisScript := "{38A3EB13-D0C4-478b-9720-4D0B2D361DB9}"
APPID_ThisScript := "ahkdemo.ahk"
funcs := ["aRegisterIDs", "aGetObject", "aCallFunc", "hello"]
server := ahkComServer(CLSID_ThisScript, APPID_ThisScript, funcs)
return

aRegisterIDs(this, CLSID, APPID){
RegisterIDs(CLSID, APPID)
}

hello(this, message){
msgbox % message
}
aGetObject(this, name){
global
return %name%
}

aCallFunc(this, func, args){
return %func%(args)
}

;; ahkcomserver()
ahkComServer(CLSID_ThisScript, APPID_ThisScript, funcs)
{
global serverReady
server := object()
 ; CLSID_ThisScript := "{38A3EB13-D0C4-478b-9720-4D0B2D361DB9}"
 ; APPID_ThisScript := "Garglet.QueryServer"

  RegisterIDs(CLSID_ThisScript, APPID_ThisScript)
for i, func in funcs
{
str .= func . ", "
}
str := SubStr(str, 1, strlen(str) - 2)

  myObj := ComDispatch("", str)
; Expose it
  if !(hRemote := ComRemote(myObj, CLSID_ThisScript))
  {
    MsgBox, 16, %A_ScriptName%, Can't remote the object!
    ExitApp
  }
server.CLSID := CLSID_ThisScript
server.APPID := APPID_ThisScript
server.hRemote := hRemote
serverReady := 1
  return server
}

#Include ComRemote.ahk
#include lib\ComDispTable.ahk
#include lib\ComDispatch.ahk
#include lib\ComVar.ahk
