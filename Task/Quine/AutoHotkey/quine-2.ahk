D(n, s)
{
   global
   Loop %n%
   {
      l := %s%%A_Index%
      If l = #
         l := "script =" . nl . "( %" . nl . script . nl . ")"
      FileAppend %l%%nl%, %A_ScriptDir%\Q.txt
   }
}
nl := Chr(13) . Chr(10)
script =
( %
D(n, s)
{
   global
   Loop %n%
   {
      l := %s%%A_Index%
      If l = #
         l := "script =" . nl . "( %" . nl . script . nl . ")"
      FileAppend %l%%nl%, %A_ScriptDir%\Q.txt
   }
}
nl := Chr(13) . Chr(10)
#
StringSplit q, script, %nl%
D(q0, "q")
)
StringSplit q, script, %nl%
D(q0, "q")
