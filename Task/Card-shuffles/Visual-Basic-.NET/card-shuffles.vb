Imports System.Runtime.CompilerServices
Imports System.Text

Module Module1

    <Extension()>
    Function AsString(Of T)(c As ICollection(Of T)) As String
        Dim sb = New StringBuilder("[")
        sb.Append(String.Join(", ", c))
        Return sb.Append("]").ToString()
    End Function

    Private rand As New Random()

    Function RiffleShuffle(Of T)(list As ICollection(Of T), flips As Integer) As List(Of T)
        Dim newList As New List(Of T)(list)

        For n = 1 To flips
            'cut the deck at the middle +/- 10%, remove the second line of the formula for perfect cutting
            Dim cutPoint As Integer = newList.Count / 2 + If(rand.Next(0, 2) = 0, -1, 1) * rand.Next(newList.Count * 0.1)

            'split the deck
            Dim left As New List(Of T)(newList.Take(cutPoint))
            Dim right As New List(Of T)(newList.Skip(cutPoint))

            newList.Clear()

            While left.Count > 0 AndAlso right.Count > 0
                'allow for imperfect riffling so that more than one card can come form the same side in a row
                'biased towards the side with more cards
                'remove the if And else And brackets for perfect riffling
                If rand.NextDouble() >= left.Count / right.Count / 2 Then
                    newList.Add(right.First())
                    right.RemoveAt(0)
                Else
                    newList.Add(left.First())
                    left.RemoveAt(0)
                End If
            End While

            'if either hand is out of cards then flip all of the other hand to the shuffled deck
            If left.Count > 0 Then
                newList.AddRange(left)
            End If
            If right.Count > 0 Then
                newList.AddRange(right)
            End If
        Next

        Return newList
    End Function

    Function OverhandShuffle(Of T)(list As ICollection(Of T), passes As Integer) As List(Of T)
        Dim mainHand As New List(Of T)(list)

        For n = 1 To passes
            Dim otherhand = New List(Of T)

            While mainHand.Count > 0
                'cut at up to 20% of the way through the deck
                Dim cutSize = rand.Next(list.Count * 0.2) + 1

                Dim temp = New List(Of T)

                'grab the next cut up to the end of the cards left in the main hand
                Dim i = 0
                While i < cutSize AndAlso mainHand.Count > 0
                    temp.Add(mainHand.First())
                    mainHand.RemoveAt(0)
                    i = i + 1
                End While

                'add them to the cards in the other hand, sometimes to the front sometimes to the back
                If rand.NextDouble() >= 0.1 Then
                    'front most of the time
                    temp.AddRange(otherhand)
                    otherhand = temp
                Else
                    'end sometimes
                    otherhand.AddRange(temp)
                End If
            End While

            'move the cards back to the main hand
            mainHand = otherhand
        Next

        Return mainHand
    End Function

    Sub Main()
        Dim list = New List(Of Integer)(Enumerable.Range(1, 20))
        Console.WriteLine(list.AsString())
        list = RiffleShuffle(list, 10)
        Console.WriteLine(list.AsString())
        Console.WriteLine()

        list = New List(Of Integer)(Enumerable.Range(1, 20))
        Console.WriteLine(list.AsString())
        list = RiffleShuffle(list, 1)
        Console.WriteLine(list.AsString())
        Console.WriteLine()

        list = New List(Of Integer)(Enumerable.Range(1, 20))
        Console.WriteLine(list.AsString())
        list = OverhandShuffle(list, 10)
        Console.WriteLine(list.AsString())
        Console.WriteLine()

        list = New List(Of Integer)(Enumerable.Range(1, 20))
        Console.WriteLine(list.AsString())
        list = OverhandShuffle(list, 1)
        Console.WriteLine(list.AsString())
        Console.WriteLine()
    End Sub

End Module
