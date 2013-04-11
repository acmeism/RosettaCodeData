string = Mary had a little lamb
StringSplit, arg, string, %A_Space%

Function(arg1,arg2,arg3,arg4,arg5)  ;Calls the function with 5 arguments.
Function()  ;Calls the function with no arguments.
return

Function(arg1="",arg2="",arg3="",arg4="",arg5="") {
  Loop,5
    If arg%A_Index% !=
      out .= arg%A_Index% "`n"
  MsgBox,% out ? out:"No non-blank arguments were passed."
}
