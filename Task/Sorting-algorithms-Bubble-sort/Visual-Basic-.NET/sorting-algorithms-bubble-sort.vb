Do Until NoMoreSwaps = True
     NoMoreSwaps = True
     For Counter = 1 To (NumberOfItems - 1)
         If List(Counter) > List(Counter + 1) Then
             NoMoreSwaps = False
             Temp = List(Counter)
             List(Counter) = List(Counter + 1)
             List(Counter + 1) = Temp
         End If
     Next
     NumberOfItems = NumberOfItems - 1
Loop
