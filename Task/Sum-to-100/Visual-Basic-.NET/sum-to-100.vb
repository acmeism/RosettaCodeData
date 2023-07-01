' Recursively iterates (increments) iteration array, returns -1 when out of "digits".
Function plusOne(iAry() As Integer, spot As Integer) As Integer
    Dim spotLim As Integer = If(spot = 0, 1, 2) ' The first "digit" has a lower limit.
    If iAry(spot) = spotLim Then ' Check if spot has reached limit
        If spot = 0 Then Return -1 ' No previous spot to increment, so indicate completed.
        iAry(spot) = 0 ' Reset current spot, and
        Return plusOne(iAry, spot - 1) ' Increment previous spot.
    Else
        iAry(spot) += 1 ' Increment current spot.
    End If
    Return spot
End Function

' Returns string sequence of operations from iAry and terms string
Function generate(iAry() As Integer, terms As String) As String
    Dim operations As String() = {"", "-", "+"} ' Possible operations.
    generate = ""
    For i As Integer = 0 To iAry.Count - 1
        generate &= operations(iAry(i)) & Mid(terms, i + 1, 1).ToString()
    Next
End Function

' Returns evaluation of string sequence
Function eval(sequence As String) As Integer
    eval = 0
    Dim term As Integer = 0, operation As Integer = 1
    For Each ch As Char In sequence
        Select Case ch
            Case "-", "+" ' New operation detected, apply previous operation to term,
                eval += If(operation = 0, -term, term) : term = 0 ' and reset term.
                operation = If(ch = "-", 0, 1) ' Note next operation.
            Case Else ' Digit detected, increase term.
                term = term * 10 + Val(ch)
        End Select
    Next
    eval += If(operation = 0, -term, term) ' Apply final term.
End Function

' Sorts a pair of List(Of Integer) by the first
Sub reSort(ByRef first As List(Of Integer), ByRef second As List(Of Integer))
    Dim lou As New List(Of ULong) ' Temporary list of ULong for sorting.
    For i As Integer = 0 To first.Count - 1
        lou.Add((CULng(first(i)) << 32) + second(i)) ' "Pack" list items.
    Next
    lou.Sort()
    For k As Integer = 0 To first.Count - 1
        first(k) = lou(k) >> 32 ' "Unpack" first list item.
        second(k) = lou(k) And &H7FFFFFFF ' "Unpack" second list item.
    Next
End Sub

' Returns first result not in sequence, assumes passed list is sorted before call,
'  uses binary search algo.
Function firstMiss(loi As List(Of Integer))
    Dim low As Integer = 0, high As Integer = loi.Count - 1, middle = (low + high) \ 2
    Do
        If loi(middle) = middle Then low = middle + 1 Else high = middle - 1
        middle = (low + high) \ 2
    Loop Until high <= low
    Return middle + If(loi(middle) = middle, 1, 0)
End Function

' Iterates through all possible operations,
'  uses a pair of List (of Integer) to tabulate solutions.
Sub Solve100(Optional terms As String = "123456789",
             Optional targSum As Integer = 100,
             Optional highNums As Integer = 10)
    Dim lastDig As Integer = Len(terms) - 1 ' The final "digit".
    Dim iAry() As Integer = New Integer(lastDig) {} ' Iterations array.
    Dim seq As String ' Sequence of numbers and operations.
    Dim sVal As Integer ' Sequence value.
    Dim sCnt As Integer = 1 ' Solution count (targSum).
    Dim res As New List(Of Integer) ' List of results.
    Dim tally As New List(Of Integer) ' Tally of results.
    Console.WriteLine("List of solutions that evaluate to 100:")
    Do ' Tabulate results until digits are exhausted.
        seq = generate(iAry, terms) ' Obtain next expression.
        sVal = eval(seq) ' Obtain next evaluation.
        If sVal >= 0 Then ' Don't bother saving the negative results.
            If res.Contains(sVal) Then tally(res.IndexOf(sVal)) += 1 _
                                  Else res.Add(sVal) : tally.Add(1)
            If sVal = targSum Then _
                Console.WriteLine(" {0,2} {1}", sCnt, seq) : sCnt += 1
        End If
    Loop Until plusOne(iAry, lastDig) < 0
    reSort(tally, res) ' Sort by tally to find result with the most solutions.
    Console.WriteLine("The sum that has the the most solutions is {0}, (at {1}).",
                      res.Last, tally.Last)
    reSort(res, tally) ' Sort by result to find first missing result and top results.
    Console.WriteLine("The lowest positive sum that can't be expressed is {0}.",
                      firstMiss(res))
    Console.WriteLine("The ten highest numbers that can be expressed are:")
    res.Reverse() ' To let us take the last items for output.
    sCnt = 0 ' Keep track of items displayed (for formatting).
    For Each item As Integer In res.Take(highNums)
        Console.Write("{0, -11}", item)
        sCnt = (sCnt + 1) Mod 5 : If sCnt = 0 Then Console.WriteLine()
    Next
End Sub

Sub Main()
    Solve100() ' if interested, try this: Solve100("987654321")
End Sub
