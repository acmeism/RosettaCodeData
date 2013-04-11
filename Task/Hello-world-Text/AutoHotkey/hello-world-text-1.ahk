DllCall("AllocConsole")
FileAppend, Goodbye`, World!, CONOUT$
FileReadLine, _, CONIN$, 1
