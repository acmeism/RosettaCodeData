#NoEnv ; Recommended for increased performance
Input, Response,,,y,n
; Waits until they press y or n, storing all characters.
StringRight, Out, Response, 1
; retrieves the ending character (which will be y or n)
Msgbox %out%
If (Out = "y")
    Msgbox You pressed Y
If (Out = "n")
    Msgbox You pressed n
ExitApp
