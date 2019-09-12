Option Base 1
Public Enum sett
    name_ = 1
    initState
    endState
    blank
    rules
End Enum
Public incrementer As Variant, threeStateBB As Variant, fiveStateBB As Variant
'-- Machine definitions
Private Sub init()
    incrementer = Array("Simple incrementer", _
        "q0", _
        "qf", _
        "B", _
         Array( _
         Array("q0", "1", "1", "right", "q0"), _
         Array("q0", "B", "1", "stay", "qf")))
    threeStateBB = Array("Three-state busy beaver", _
       "a", _
       "halt", _
       "0", _
        Array( _
        Array("a", "0", "1", "right", "b"), _
        Array("a", "1", "1", "left", "c"), _
        Array("b", "0", "1", "left", "a"), _
        Array("b", "1", "1", "right", "b"), _
        Array("c", "0", "1", "left", "b"), _
        Array("c", "1", "1", "stay", "halt")))
    fiveStateBB = Array("Five-state busy beaver", _
        "A", _
        "H", _
        "0", _
         Array( _
         Array("A", "0", "1", "right", "B"), _
         Array("A", "1", "1", "left", "C"), _
         Array("B", "0", "1", "right", "C"), _
         Array("B", "1", "1", "right", "B"), _
         Array("C", "0", "1", "right", "D"), _
         Array("C", "1", "0", "left", "E"), _
         Array("D", "0", "1", "left", "A"), _
         Array("D", "1", "1", "left", "D"), _
         Array("E", "0", "1", "stay", "H"), _
         Array("E", "1", "0", "left", "A")))
End Sub

Private Sub show(state As String, headpos As Long, tape As Collection)
    Debug.Print " "; state; String$(7 - Len(state), " "); "| ";
    For p = 1 To tape.Count
        Debug.Print IIf(p = headpos, "[" & tape(p) & "]", " " & tape(p) & " ");
    Next p
    Debug.Print
End Sub

'-- a universal turing machine
Private Sub UTM(machine As Variant, tape As Collection, Optional countOnly As Long = 0)
    Dim state As String: state = machine(initState)
    Dim headpos As Long: headpos = 1
    Dim counter As Long, rule As Variant
    Debug.Print machine(name_); vbCrLf; String$(Len(machine(name_)), "=")
    If Not countOnly Then Debug.Print " State  | Tape [head]" & vbCrLf & "---------------------"
    Do While True
        If headpos > tape.Count Then
            tape.Add machine(blank)
        Else
            If headpos < 1 Then
                tape.Add machine(blank), Before:=1
                headpos = 1
            End If
        End If
        If Not countOnly Then show state, headpos, tape
        For i = LBound(machine(rules)) To UBound(machine(rules))
            rule = machine(rules)(i)
            If rule(1) = state And rule(2) = tape(headpos) Then
                tape.Remove headpos
                If headpos > tape.Count Then
                    tape.Add rule(3)
                Else
                    tape.Add rule(3), Before:=headpos
                End If
                If rule(4) = "left" Then headpos = headpos - 1
                If rule(4) = "right" Then headpos = headpos + 1
                state = rule(5)
                Exit For
            End If
        Next i
        counter = counter + 1
        If counter Mod 100000 = 0 Then
            Debug.Print counter
            DoEvents
            DoEvents
        End If
        If state = machine(endState) Then Exit Do
    Loop
    DoEvents
    If countOnly Then
        Debug.Print "Steps taken: ", counter
    Else
        show state, headpos, tape
        Debug.Print
    End If
End Sub

Public Sub main()
    init
    Dim tap As New Collection
    tap.Add "1": tap.Add "1": tap.Add "1"
    UTM incrementer, tap
    Set tap = New Collection
    UTM threeStateBB, tap
    Set tap = New Collection
    UTM fiveStateBB, tap, countOnly:=-1
End Sub
