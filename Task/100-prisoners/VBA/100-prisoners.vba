Sub HundredPrisoners()

    NumberOfPrisoners = Int(InputBox("Number of Prisoners", "Prisoners", 100))
    Tries = Int(InputBox("Numer of Tries", "Tries", 1000))
    Selections = Int(InputBox("Number of Selections", "Selections", NumberOfPrisoners / 2))

    StartTime = Timer

    AllFoundOptimal = 0
    AllFoundRandom = 0
    AllFoundRandomMem = 0

    For i = 1 To Tries
        OptimalCount = HundredPrisoners_Optimal(NumberOfPrisoners, Selections)
        RandomCount = HundredPrisoners_Random(NumberOfPrisoners, Selections)
        RandomMemCount = HundredPrisoners_Random_Mem(NumberOfPrisoners, Selections)

        If OptimalCount = NumberOfPrisoners Then
            AllFoundOptimal = AllFoundOptimal + 1
        End If
        If RandomCount = NumberOfPrisoners Then
            AllFoundRandom = AllFoundRandom + 1
        End If
        If RandomMemCount = NumberOfPrisoners Then
            AllFoundRandomMem = AllFoundRandomMem + 1
        End If
    Next i


    ResultString = "Optimal: " & AllFoundOptimal & " of " & Tries & ": " & AllFoundOptimal / Tries * 100 & "%"
    ResultString = ResultString & Chr(13) & "Random: " & AllFoundRandom & " of " & Tries & ": " & AllFoundRandom / Tries * 100 & "%"
    ResultString = ResultString & Chr(13) & "RandomMem: " & AllFoundRandomMem & " of " & Tries & ": " & AllFoundRandomMem / Tries * 100 & "%"

    EndTime = Timer

    ResultString = ResultString & Chr(13) & "Elapsed Time: " & Round(EndTime - StartTime, 2) & " s"
    ResultString = ResultString & Chr(13) & "Trials/sec: " & Tries / Round(EndTime - StartTime, 2)

    MsgBox ResultString, vbOKOnly, "Results"

End Sub

Function HundredPrisoners_Optimal(ByVal NrPrisoners, ByVal NrSelections) As Long
    Dim DrawerArray() As Long

    ReDim DrawerArray(NrPrisoners - 1)

    For Counter = LBound(DrawerArray) To UBound(DrawerArray)
        DrawerArray(Counter) = Counter + 1
    Next Counter

    FisherYates DrawerArray

    For i = 1 To NrPrisoners
        NumberFromDrawer = DrawerArray(i - 1)
        For j = 1 To NrSelections - 1
            If NumberFromDrawer = i Then
                FoundOwnNumber = FoundOwnNumber + 1
                Exit For
            End If
            NumberFromDrawer = DrawerArray(NumberFromDrawer - 1)
        Next j
    Next i
    HundredPrisoners_Optimal = FoundOwnNumber
End Function

Function HundredPrisoners_Random(ByVal NrPrisoners, ByVal NrSelections) As Long
    Dim DrawerArray() As Long
    ReDim DrawerArray(NrPrisoners - 1)

    FoundOwnNumber = 0

    For Counter = LBound(DrawerArray) To UBound(DrawerArray)
        DrawerArray(Counter) = Counter + 1
    Next Counter

    FisherYates DrawerArray


    For i = 1 To NrPrisoners
        For j = 1 To NrSelections
            RandomDrawer = Int(NrPrisoners * Rnd)
            NumberFromDrawer = DrawerArray(RandomDrawer)
            If NumberFromDrawer = i Then
                FoundOwnNumber = FoundOwnNumber + 1
                Exit For
            End If
        Next j
    Next i
    HundredPrisoners_Random = FoundOwnNumber
End Function

Function HundredPrisoners_Random_Mem(ByVal NrPrisoners, ByVal NrSelections) As Long
    Dim DrawerArray() As Long
    Dim SelectionArray() As Long
    ReDim DrawerArray(NrPrisoners - 1)
    ReDim SelectionArray(NrPrisoners - 1)

    HundredPrisoners_Random_Mem = 0
    FoundOwnNumberMem = 0

    For Counter = LBound(DrawerArray) To UBound(DrawerArray)
        DrawerArray(Counter) = Counter + 1
    Next Counter

    For Counter = LBound(SelectionArray) To UBound(SelectionArray)
        SelectionArray(Counter) = Counter + 1
    Next Counter

    FisherYates DrawerArray

    For i = 1 To NrPrisoners
        FisherYates SelectionArray
        For j = 1 To NrSelections
            NumberFromDrawer = DrawerArray(SelectionArray(j - 1) - 1)
            If NumberFromDrawer = i Then
                FoundOwnNumberMem = FoundOwnNumberMem + 1
                Exit For
            End If
        Next j
    Next i
    HundredPrisoners_Random_Mem = FoundOwnNumberMem
End Function

Sub FisherYates(ByRef InputArray() As Long)

    Dim Temp As Long
    Dim PosRandom As Long
    Dim Counter As Long
    Dim Upper As Long
    Dim Lower As Long

    Lower = LBound(InputArray)
    Upper = UBound(InputArray)

    Randomize

    For Counter = Upper To (Lower + 1) Step -1
        PosRandom = CLng(Int((Counter - Lower + 1) * Rnd + Lower))
        Temp = InputArray(Counter)
        InputArray(Counter) = InputArray(PosRandom)
        InputArray(PosRandom) = Temp
    Next Counter

End Sub
