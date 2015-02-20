Global stack$

Function RPN(expr$)
Debug.Print "Expression:"
Debug.Print expr$
Debug.Print "Input", "Operation", "Stack after"

stack$ = ""
token$ = "#"
i = 1
token$ = Split(expr$)(i - 1) 'split is base 0
token2$ = " " + token$ + " "

Do
    Debug.Print "Token "; i; ": "; token$,
    'operation
    If InStr("+-*/^", token$) <> 0 Then
        Debug.Print "operate",
        op2$ = pop$()
        op1$ = pop$()
        If op1$ = "" Then
            Debug.Print "Error: stack empty for "; i; "-th token: "; token$
            End
        End If

        op1 = Val(op1$)
        op2 = Val(op2$)

        Select Case token$
        Case "+"
            res = CDbl(op1) + CDbl(op2)
        Case "-"
            res = CDbl(op1) - CDbl(op2)
        Case "*"
            res = CDbl(op1) * CDbl(op2)
        Case "/"
            res = CDbl(op1) / CDbl(op2)
        Case "^"
            res = CDbl(op1) ^ CDbl(op2)
        End Select

        Call push2(str$(res))
    'default:number
    Else
        Debug.Print "push",
        Call push2(token$)
    End If
    Debug.Print "Stack: "; reverse$(stack$)
    i = i + 1
    If i > Len(Join(Split(expr, " "), "")) Then
        token$ = ""
    Else
        token$ = Split(expr$)(i - 1) 'base 0
        token2$ = " " + token$ + " "
    End If
Loop Until token$ = ""

Debug.Print
Debug.Print "Result:"; pop$()
'extra$ = pop$()
If stack <> "" Then
    Debug.Print "Error: extra things on a stack: "; stack$
End If
End
End Function

'---------------------------------------
Function reverse$(s$)
    reverse$ = ""
    token$ = "#"
    While token$ <> ""
        i = i + 1
        token$ = Split(s$, "|")(i - 1) 'split is base 0
        reverse$ = token$ & " " & reverse$
    Wend
End Function
'---------------------------------------
Sub push2(s$)
    stack$ = s$ + "|" + stack$ 'stack
End Sub

Function pop$()
    'it does return empty on empty stack
    pop$ = Split(stack$, "|")(0)
    stack$ = Mid$(stack$, InStr(stack$, "|") + 1)
End Function
