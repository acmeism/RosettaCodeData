SetTitleMatchMode 2
EM_SETSEL := 0x00B1

Run notepad,,,pid
WinWaitActive ahk_pid %pid%
ControlSetText, Edit1, % text := "AutoHotkey was the first to implement this task! ", ahk_pid %pid%

pVoice := ComObjCreate("Sapi.spvoice"), i := 1 ; the spvoice COM Object ships with the OS

; parse the text
While lf := SubStr(text, i, 1)
{
   If lf = %A_Space%
   {
      SendMessage, EM_SetSel, % i-StrLen(word)-1, % i-1, Edit1, ahk_pid %pid%
      pVoice.speak(word), word := "", i++
   }
   Else word .= lf, i++
}
