Module Module1

    Class Shipment
        Public Sub New(q As Double, cpu As Double, rv As Integer, cv As Integer)
            Quantity = q
            CostPerUnit = cpu
            R = rv
            C = cv
        End Sub

        Public ReadOnly Property CostPerUnit() As Double

        Public Property Quantity() As Double

        Public ReadOnly Property R As Integer

        Public ReadOnly Property C As Integer

        Public Shared Operator =(s1 As Shipment, s2 As Shipment) As Boolean
            Return s1.CostPerUnit = s2.CostPerUnit _
                AndAlso s1.Quantity = s2.Quantity _
                AndAlso s1.R = s2.R _
                AndAlso s1.C = s2.C
        End Operator

        Public Shared Operator <>(s1 As Shipment, s2 As Shipment) As Boolean
            Return s1.CostPerUnit <> s2.CostPerUnit _
                OrElse s1.Quantity <> s2.Quantity _
                OrElse s1.R <> s2.R _
                OrElse s1.C <> s2.C
        End Operator
    End Class

    Class Program
        Private demand() As Integer
        Private supply() As Integer
        Private costs(,) As Double
        Private matrix(,) As Shipment

        Sub Init(filename As String)
            Dim file = My.Computer.FileSystem.OpenTextFileReader(filename)
            Dim line = file.ReadLine
            Dim numArr = line.Split
            Dim numSources = Integer.Parse(numArr(0))
            Dim numDestinations = Integer.Parse(numArr(1))

            Dim src As New List(Of Integer)
            Dim dst As New List(Of Integer)

            line = file.ReadLine
            numArr = line.Split
            For i = 1 To numSources
                src.Add(Integer.Parse(numArr(i - 1)))
            Next

            line = file.ReadLine
            numArr = line.Split
            For i = 1 To numDestinations
                dst.Add(Integer.Parse(numArr(i - 1)))
            Next

            REM fix imbalance
            Dim totalSrc = src.Sum
            Dim totalDst = dst.Sum
            If totalSrc > totalDst Then
                dst.Add(totalSrc - totalDst)
            ElseIf totalDst > totalSrc Then
                src.Add(totalDst - totalSrc)
            End If

            supply = src.ToArray
            demand = dst.ToArray

            ReDim costs(supply.Length - 1, demand.Length - 1)
            ReDim matrix(supply.Length - 1, demand.Length - 1)

            For i = 1 To numSources
                line = file.ReadLine
                numArr = line.Split
                For j = 1 To numDestinations
                    costs(i - 1, j - 1) = Integer.Parse(numArr(j - 1))
                Next
            Next
        End Sub

        Sub NorthWestCornerRule()
            Dim northwest = 1
            For r = 1 To supply.Length
                For c = northwest To demand.Length
                    Dim quantity = Math.Min(supply(r - 1), demand(c - 1))
                    If quantity > 0 Then
                        matrix(r - 1, c - 1) = New Shipment(quantity, costs(r - 1, c - 1), r - 1, c - 1)

                        supply(r - 1) -= quantity
                        demand(c - 1) -= quantity

                        If supply(r - 1) = 0 Then
                            northwest = c
                            Exit For
                        End If
                    End If
                Next
            Next
        End Sub

        Sub SteppingStone()
            Dim maxReduction = 0.0
            Dim move() As Shipment = Nothing
            Dim leaving As Shipment = Nothing

            FixDegenerateCase()

            For r = 1 To supply.Length
                For c = 1 To demand.Length
                    If Not IsNothing(matrix(r - 1, c - 1)) Then
                        Continue For
                    End If

                    Dim trial As New Shipment(0, costs(r - 1, c - 1), r - 1, c - 1)
                    Dim path = GetClosedPath(trial)

                    Dim reduction = 0.0
                    Dim lowestQuanity = Integer.MaxValue
                    Dim leavingCandidate As Shipment = Nothing

                    Dim plus = True
                    For Each s In path
                        If plus Then
                            reduction += s.CostPerUnit
                        Else
                            reduction -= s.CostPerUnit
                            If s.Quantity < lowestQuanity Then
                                leavingCandidate = s
                                lowestQuanity = s.Quantity
                            End If
                        End If
                        plus = Not plus
                    Next
                    If reduction < maxReduction Then
                        move = path
                        leaving = leavingCandidate
                        maxReduction = reduction
                    End If
                Next
            Next

            If Not IsNothing(move) Then
                Dim q = leaving.Quantity
                Dim plus = True
                For Each s In move
                    s.Quantity += If(plus, q, -q)
                    matrix(s.R, s.C) = If(s.Quantity = 0, Nothing, s)
                    plus = Not plus
                Next
                SteppingStone()
            End If
        End Sub

        Sub FixDegenerateCase()
            Const eps = Double.Epsilon
            If supply.Length + demand.Length - 1 <> MatrixToList().Count Then
                For r = 1 To supply.Length
                    For c = 1 To demand.Length
                        If IsNothing(matrix(r - 1, c - 1)) Then
                            Dim dummy As New Shipment(eps, costs(r - 1, c - 1), r - 1, c - 1)
                            If GetClosedPath(dummy).Length = 0 Then
                                matrix(r - 1, c - 1) = dummy
                                Return
                            End If
                        End If
                    Next
                Next
            End If
        End Sub

        Function MatrixToList() As List(Of Shipment)
            Dim newList As New List(Of Shipment)
            For Each item In matrix
                If Not IsNothing(item) Then
                    newList.Add(item)
                End If
            Next
            Return newList
        End Function

        Function GetClosedPath(s As Shipment) As Shipment()
            Dim path = MatrixToList()
            path.Add(s)

            REM remove (and keep removing) elements that do not have a veritcal AND horizontal neighbor
            Dim before As Integer
            Do
                before = path.Count
                path.RemoveAll(Function(ship)
                                   Dim nbrs = GetNeighbors(ship, path)
                                   Return IsNothing(nbrs(0)) OrElse IsNothing(nbrs(1))
                               End Function)
            Loop While before <> path.Count

            REM place the remaining elements in the correct plus-minus order
            Dim stones = path.ToArray
            Dim prev = s
            For i = 1 To stones.Length
                stones(i - 1) = prev
                prev = GetNeighbors(prev, path)((i - 1) Mod 2)
            Next
            Return stones
        End Function

        Function GetNeighbors(s As Shipment, lst As List(Of Shipment)) As Shipment()
            Dim nbrs() As Shipment = {Nothing, Nothing}
            For Each o In lst
                If o <> s Then
                    If o.R = s.R AndAlso IsNothing(nbrs(0)) Then
                        nbrs(0) = o
                    ElseIf o.C = s.C AndAlso IsNothing(nbrs(1)) Then
                        nbrs(1) = o
                    End If
                    If Not IsNothing(nbrs(0)) AndAlso Not IsNothing(nbrs(1)) Then
                        Exit For
                    End If
                End If
            Next
            Return nbrs
        End Function

        Sub PrintResult(filename As String)
            Console.WriteLine("Optimal solution {0}" + vbNewLine, filename)
            Dim totalCosts = 0.0

            For r = 1 To supply.Length
                For c = 1 To demand.Length
                    Dim s = matrix(r - 1, c - 1)
                    If Not IsNothing(s) AndAlso s.R = r - 1 AndAlso s.C = c - 1 Then
                        Console.Write(" {0,3} ", s.Quantity)
                        totalCosts += (s.Quantity * s.CostPerUnit)
                    Else
                        Console.Write("  -  ")
                    End If
                Next
                Console.WriteLine()
            Next
            Console.WriteLine(vbNewLine + "Total costs: {0}" + vbNewLine, totalCosts)
        End Sub
    End Class

    Sub Main()
        For Each filename In {"input1.txt", "input2.txt", "input3.txt"}
            Dim p As New Program
            p.Init(filename)
            p.NorthWestCornerRule()
            p.SteppingStone()
            p.PrintResult(filename)
        Next
    End Sub

End Module
