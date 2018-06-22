Sub C_S_Select_Case()
'With Strings
Dim A$, C&

    A = "Hello"
    Select Case A
        Case "World"
            Debug.Print "A = World"
        Case "Hello"
            Debug.Print "A = Hello"
        Case Else
            Debug.Print "You make a mistake"
    End Select
'With numerics
    C = 11
    Select Case C
        Case Is <= 10
            Debug.Print "C <= 10"
        Case Is < 20, Is > 10
            Debug.Print "10 < C < 20"
        Case Is >= 20
            Debug.Print "C >= 20"
    End Select
'Select Case Boolean
    'With Strings
    Select Case False
        Case A <> "Hello"
            Debug.Print "A = Hello"
        Case A Like "*orl*"
            Debug.Print "A Not Like *orl*"
        Case Else
            Debug.Print "You make a mistake"
    End Select                  'return : "A = Hello"
    'Other conditions's order
    Select Case False
        Case A Like "*orl*"
            Debug.Print "A Not Like *orl*"
        Case A <> "Hello"
            Debug.Print "A = Hello"
        Case Else
            Debug.Print "You make a mistake"
    End Select                  'return : "A Not Like *orl*"
    'With numerics
    Select Case True
        Case C <= 10
            Debug.Print "C <= 10"
        Case C < 20, C > 10
            Debug.Print "10 < C < 20"
        Case C >= 20
            Debug.Print "C >= 20"
    End Select
End Sub
