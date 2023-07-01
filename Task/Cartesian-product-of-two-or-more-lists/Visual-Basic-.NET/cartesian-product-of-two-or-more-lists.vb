Imports System.Runtime.CompilerServices

Module Module1

    <Extension()>
    Function CartesianProduct(Of T)(sequences As IEnumerable(Of IEnumerable(Of T))) As IEnumerable(Of IEnumerable(Of T))
        Dim emptyProduct As IEnumerable(Of IEnumerable(Of T)) = {Enumerable.Empty(Of T)}
        Return sequences.Aggregate(emptyProduct, Function(accumulator, sequence) From acc In accumulator From item In sequence Select acc.Concat({item}))
    End Function

    Sub Main()
        Dim empty(-1) As Integer
        Dim list1 = {1, 2}
        Dim list2 = {3, 4}
        Dim list3 = {1776, 1789}
        Dim list4 = {7, 12}
        Dim list5 = {4, 14, 23}
        Dim list6 = {0, 1}
        Dim list7 = {1, 2, 3}
        Dim list8 = {30}
        Dim list9 = {500, 100}

        For Each sequnceList As Integer()() In {
            ({list1, list2}),
            ({list2, list1}),
            ({list1, empty}),
            ({empty, list1}),
            ({list3, list4, list5, list6}),
            ({list7, list8, list9}),
            ({list7, empty, list9})
        }
            Dim cart = sequnceList.CartesianProduct().Select(Function(tuple) $"({String.Join(", ", tuple)})")
            Console.WriteLine($"{{{String.Join(", ", cart)}}}")
        Next
    End Sub

End Module
