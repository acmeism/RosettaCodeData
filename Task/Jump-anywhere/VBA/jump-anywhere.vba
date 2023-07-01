Public Sub jump()
    Debug.Print "VBA only allows"
    GoTo 1
    Debug.Print "no global jumps"
1:
    Debug.Print "jumps in procedures with GoTo"
    Debug.Print "However,"
    On 2 GoSub one, two
    Debug.Print "named in the list after 'GoSub'"
    Debug.Print "and execution will continue on the next line"
    On 1 GoTo one, two
    Debug.Print "For On Error, see Exceptions"
one:
    Debug.Print "On <n> GoTo let you jump to the n-th label"
    Debug.Print "and won't let you continue."
    Exit Sub
two:
    Debug.Print "On <n> GoSub let you jump to the n-th label": Return
End Sub
