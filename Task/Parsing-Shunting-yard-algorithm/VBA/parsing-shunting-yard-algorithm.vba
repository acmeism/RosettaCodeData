Option Explicit
Option Base 1

Function ShuntingYard(strInfix As String) As String
Dim i As Long, j As Long, token As String, tokenArray() As String
Dim stack() As Variant, queue() As Variant, discard As String
Dim op1 As String, op2 As String

Debug.Print strInfix

' Get tokens
tokenArray = Split(strInfix)

' Initialize array (removed later)
ReDim stack(1)
ReDim queue(1)

' Loop over tokens
Do While 1
    i = i + 1
    If i - 1 > UBound(tokenArray) Then
        Exit Do
    Else
        token = tokenArray(i - 1) 'i-1 due to Split returning a Base 0
    End If
    If token = "" Then: Exit Do

    ' Print
    Debug.Print i, token, Join(stack, ","), Join(queue, ",")
    ' If-loop over tokens (either brackets, operators, or numbers)
    If token = "(" Then
        stack = push(token, stack)
    ElseIf token = ")" Then
        While Peek(stack) <> "("
            queue = push(pop(stack), queue)
        Wend
        discard = pop(stack) 'discard "("
    ElseIf isOperator(token) Then
        op1 = token
        Do While (isOperator(Peek(stack)))
'            Debug.Print Peek(stack)
            op2 = Peek(stack)
            If op2 <> "^" And precedence(op1) = precedence(op2) Then
                '"^" is the only right-associative operator
                queue = push(pop(stack), queue)
            ElseIf precedence(op1$) < precedence(op2$) Then
                queue = push(pop(stack), queue)
            Else
                Exit Do
            End If
        Loop
        stack = push(op1, stack)
    Else   'number
        'actually, wrong operator could end up here, like say %
        'If the token is a number, then add it to the output queue.
        queue = push(CStr(token), queue)
    End If
Loop

While stack(1) <> ""
    If Peek(stack) = "(" Then Debug.Print "no matching ')'": End
    queue = push(pop(stack), queue)
Wend

' Print final output
ShuntingYard = Join(queue, " ")
Debug.Print "Output:"
Debug.Print ShuntingYard
End Function

'------------------------------------------
Function isOperator(op As String) As Boolean
    isOperator = InStr("+-*/^", op) <> 0 And Len(op$) = 1
End Function

Function precedence(op As String) As Integer
    If isOperator(op$) Then
        precedence = 1 _
            - (InStr("+-*/^", op$) <> 0) _
            - (InStr("*/^", op$) <> 0) _
            - (InStr("^", op$) <> 0)
    End If
End Function

'------------------------------------------
Function push(str, stack) As Variant
Dim out() As Variant, i As Long
If Not IsEmpty(stack(1)) Then
    out = stack
    ReDim Preserve out(1 To UBound(stack) + 1)
    out(UBound(out)) = str
Else
    ReDim out(1 To 1)
    out(1) = str
End If
push = out
End Function

Function pop(stack)
pop = stack(UBound(stack))
If UBound(stack) > 1 Then
    ReDim Preserve stack(1 To UBound(stack) - 1)
Else
    stack(1) = ""
End If
End Function

Function Peek(stack)
    Peek = stack(UBound(stack))
End Function
