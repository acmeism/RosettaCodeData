#include once "windows.bi"

Dim ki(0 To 7) As INPUT_

' A
ki(0).type = INPUT_KEYBOARD
ki(0).ki.wVk = Asc("A")
ki(0).ki.dwFlags = 0
ki(1).type = INPUT_KEYBOARD
ki(1).ki.wVk = Asc("A")
ki(1).ki.dwFlags = KEYEVENTF_KEYUP

' B
ki(2).type = INPUT_KEYBOARD
ki(2).ki.wVk = Asc("B")
ki(2).ki.dwFlags = 0
ki(3).type = INPUT_KEYBOARD
ki(3).ki.wVk = Asc("B")
ki(3).ki.dwFlags = KEYEVENTF_KEYUP

' C
ki(4).type = INPUT_KEYBOARD
ki(4).ki.wVk = Asc("C")
ki(4).ki.dwFlags = 0
ki(5).type = INPUT_KEYBOARD
ki(5).ki.wVk = Asc("C")
ki(5).ki.dwFlags = KEYEVENTF_KEYUP

' ENTER (VK_RETURN = &HD)
ki(6).type = INPUT_KEYBOARD
ki(6).ki.wVk = VK_RETURN
ki(6).ki.dwFlags = 0
ki(7).type = INPUT_KEYBOARD
ki(7).ki.wVk = VK_RETURN
ki(7).ki.dwFlags = KEYEVENTF_KEYUP

Print "Make the target window active. Sending keys in 3 seconds..."
Sleep 3000

SendInput(Ubound(ki), @ki(0), Len(INPUT_))
