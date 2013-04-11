DllCall("AllocConsole")
FileAppend, please type something`n, CONOUT$
FileReadLine, line, CONIN$, 1
msgbox % line
FileAppend, please type '75000'`n, CONOUT$
FileReadLine, line, CONIN$, 1
msgbox % line
