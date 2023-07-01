Imports System.Math

Module Module1
    Const MAXPRIME = 99                             ' upper bound for the prime factors
    Const MAXPARENT = 99                            ' greatest parent number

    Const NBRCHILDREN = 547100                      ' max number of children (total descendants)

    Public Primes As New Collection()               ' table of the prime factors
    Public PrimesR As New Collection()              ' table of the prime factors in reversed order
    Public Ancestors As New Collection()            ' table of the parent's ancestors

    Public Parents(MAXPARENT + 1) As Integer        ' index table of the root descendant (per parent)
    Public CptDescendants(MAXPARENT + 1) As Integer ' counter table of the descendants (per parent)
    Public Children(NBRCHILDREN) As ChildStruct     ' table of the whole descendants
    Public iChildren As Integer                     ' max index of the Children table

    Public Delimiter As String = ", "
    Public Structure ChildStruct
        Public Child As Long
        Public pLower As Integer
        Public pHigher As Integer
    End Structure
    Sub Main()
        Dim Parent As Short
        Dim Sum As Short
        Dim i As Short
        Dim TotDesc As Integer = 0
        Dim MidPrime As Integer

        If GetPrimes(Primes, MAXPRIME) = vbFalse Then
            Return
        End If

        For i = Primes.Count To 1 Step -1
            PrimesR.Add(Primes.Item(i))
        Next

        MidPrime = PrimesR.Item(1) / 2

        For Each Prime In PrimesR
            Parents(Prime) = InsertChild(Parents(Prime), Prime)
            CptDescendants(Prime) += 1

            If Prime > MidPrime Then
                Continue For
            End If

            For Parent = 1 To MAXPARENT
                Sum = Parent + Prime

                If Sum > MAXPARENT Then
                    Exit For
                End If

                If Parents(Parent) Then
                    InsertPreorder(Parents(Parent), Sum, Prime)
                    CptDescendants(Sum) += CptDescendants(Parent)
                End If
            Next
        Next

        RemoveFalseChildren()

        If MAXPARENT > MAXPRIME Then
            If GetPrimes(Primes, MAXPARENT) = vbFalse Then
                Return
            End If
        End If

        FileOpen(1, "Ancestors.txt", OpenMode.Output)

        For Parent = 1 To MAXPARENT
            GetAncestors(Parent)
            PrintLine(1, "[" & Parent.ToString & "] Level: " & Ancestors.Count.ToString)

            If Ancestors.Count Then
                Print(1, "Ancestors: " & Ancestors.Item(1).ToString)
                For i = 2 To Ancestors.Count
                    Print(1, ", " & Ancestors.Item(i).ToString)
                Next
                PrintLine(1)
                Ancestors.Clear()
            Else
                PrintLine(1, "Ancestors: None")
            End If

            If CptDescendants(Parent) Then
                PrintLine(1, "Descendants: " & CptDescendants(Parent).ToString)
                Delimiter = ""
                PrintDescendants(Parents(Parent))
                PrintLine(1)
                TotDesc += CptDescendants(Parent)
            Else
                PrintLine(1, "Descendants: None")
            End If

            PrintLine(1)
        Next
        Primes.Clear()
        PrimesR.Clear()
        PrintLine(1, "Total descendants " & TotDesc.ToString)
        PrintLine(1)
        FileClose(1)
    End Sub
    Function InsertPreorder(_index As Integer, _sum As Short, _prime As Short)
        Parents(_sum) = InsertChild(Parents(_sum), Children(_index).Child * _prime)

        If Children(_index).pLower Then
            InsertPreorder(Children(_index).pLower, _sum, _prime)
        End If

        If Children(_index).pHigher Then
            InsertPreorder(Children(_index).pHigher, _sum, _prime)
        End If

        Return Nothing
    End Function
    Function InsertChild(_index As Integer, _child As Long) As Integer
        If _index Then
            If _child <= Children(_index).Child Then
                Children(_index).pLower = InsertChild(Children(_index).pLower, _child)
            Else
                Children(_index).pHigher = InsertChild(Children(_index).pHigher, _child)
            End If
        Else
            iChildren += 1
            _index = iChildren
            Children(_index).Child = _child
            Children(_index).pLower = 0
            Children(_index).pHigher = 0
        End If

        Return _index
    End Function
    Function RemoveFalseChildren()
        Dim Exclusions As New Collection

        Exclusions.Add(4)
        For Each Prime In Primes
            Exclusions.Add(Prime)
        Next

        For Each ex In Exclusions
            Parents(ex) = Children(Parents(ex)).pHigher
            CptDescendants(ex) -= 1
        Next

        Exclusions.Clear()
        Return Nothing
    End Function
    Function GetAncestors(_child As Short)
        Dim Child As Short = _child
        Dim Parent As Short = 0

        For Each Prime In Primes
            If Child = 1 Then
                Exit For
            End If
            While Child Mod Prime = 0
                Child /= Prime
                Parent += Prime
            End While
        Next

        If Parent = _child Or _child = 1 Then
            Return Nothing
        End If

        GetAncestors(Parent)
        Ancestors.Add(Parent)
        Return Nothing
    End Function
    Function PrintDescendants(_index As Integer)
        If Children(_index).pLower Then
            PrintDescendants(Children(_index).pLower)
        End If

        Print(1, Delimiter.ToString & Children(_index).Child.ToString)
        Delimiter = ", "

        If Children(_index).pHigher Then
            PrintDescendants(Children(_index).pHigher)
        End If

        Return Nothing
    End Function
    Function GetPrimes(ByRef _primes As Object, Optional _maxPrime As Integer = 2) As Boolean
        Dim Value As Integer = 3
        Dim Max As Integer
        Dim Prime As Integer

        If _maxPrime < 2 Then
            Return vbFalse
        End If

        _primes.Add(2)

        While Value <= _maxPrime
            Max = Floor(Sqrt(Value))

            For Each Prime In _primes
                If Prime > Max Then
                    _primes.Add(Value)
                    Exit For
                End If

                If Value Mod Prime = 0 Then
                    Exit For
                End If
            Next

            Value += 2
        End While

        Return vbTrue
    End Function
End Module
