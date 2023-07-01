'The combination of holding to the second fork
'(HOLDON=True) and all philosophers start
'with same hand (DIJKSTRASOLUTION=False) leads
'to a deadlock. To prevent deadlock
'set HOLDON=False, and DIJKSTRASOLUTION=True.
Public Const HOLDON = False
Public Const DIJKSTRASOLUTION = True
Public Const X = 10 'chance to continue eating/thinking
Public Const GETS = 0
Public Const PUTS = 1
Public Const EATS = 2
Public Const THKS = 5
Public Const FRSTFORK = 0
Public Const SCNDFORK = 1
Public Const SPAGHETI = 0
Public Const UNIVERSE = 1
Public Const MAXCOUNT = 100000
Public Const PHILOSOPHERS = 5
Public semaphore(PHILOSOPHERS - 1) As Integer
Public positi0n(1, PHILOSOPHERS - 1) As Integer
Public programcounter(PHILOSOPHERS - 1) As Long
Public statistics(PHILOSOPHERS - 1, 5, 1) As Long
Public names As Variant
Private Sub init()
    names = [{"Aquinas","Babbage","Carroll","Derrida","Erasmus"}]
    For j = 0 To PHILOSOPHERS - 2
        positi0n(0, j) = j + 1 'first fork in right hand
        positi0n(1, j) = j     'second fork in left hand
    Next j
    If DIJKSTRASOLUTION Then
        positi0n(0, PHILOSOPHERS - 1) = j '  first fork in left hand
        positi0n(1, PHILOSOPHERS - 1) = 0 'second fork in right hand
    Else
        positi0n(0, PHILOSOPHERS - 1) = 0 'first fork in right hand
        positi0n(1, PHILOSOPHERS - 1) = j 'second fork in left hand
    End If
End Sub
Private Sub philosopher(subject As Integer, verb As Integer, objekt As Integer)
    statistics(subject, verb, objekt) = statistics(subject, verb, objekt) + 1
    If verb < 2 Then
        If semaphore(positi0n(objekt, subject)) <> verb Then
            If Not HOLDON Then
                'can't get a fork, release first fork if subject has it, and
                'this won't toggle the semaphore if subject hasn't firt fork
                semaphore(positi0n(FRSTFORK, subject)) = 1 - objekt
                'next round back to try to get first fork
                programcounter(subject) = 0
            End If
        Else
            'just toggle semaphore and move on
            semaphore(positi0n(objekt, subject)) = 1 - verb
            programcounter(subject) = (programcounter(subject) + 1) Mod 6
        End If
    Else
        'when eating or thinking, (100*(X-1)/X)% continue eating or thinking
        '(100/X)% advance program counter
        programcounter(subject) = IIf(X * Rnd > 1, verb, verb + 1) Mod 6
    End If
End Sub
Private Sub dine()
    Dim ph As Integer
    Do While TC < MAXCOUNT
        For ph = 0 To PHILOSOPHERS - 1
            Select Case programcounter(ph)
                Case 0: philosopher ph, GETS, FRSTFORK
                Case 1: philosopher ph, GETS, SCNDFORK
                Case 2: philosopher ph, EATS, SPAGHETI
                Case 3: philosopher ph, PUTS, FRSTFORK
                Case 4: philosopher ph, PUTS, SCNDFORK
                Case 5: philosopher ph, THKS, UNIVERSE
            End Select
            TC = TC + 1
        Next ph
    Loop
End Sub
Private Sub show()
    Debug.Print "Stats", "Gets", "Gets", "Eats", "Puts", "Puts", "Thinks"
    Debug.Print "", "First", "Second", "Spag-", "First", "Second", "About"
    Debug.Print "", "Fork", "Fork", "hetti", "Fork", "Fork", "Universe"
    For subject = 0 To PHILOSOPHERS - 1
        Debug.Print names(subject + 1),
        For objekt = 0 To 1
            Debug.Print statistics(subject, GETS, objekt),
        Next objekt
        Debug.Print statistics(subject, EATS, SPAGHETI),
        For objekt = 0 To 1
            Debug.Print statistics(subject, PUTS, objekt),
        Next objekt
        Debug.Print statistics(subject, THKS, UNIVERSE)
    Next subject
End Sub
Public Sub main()
    init
    dine
    show
End Sub
