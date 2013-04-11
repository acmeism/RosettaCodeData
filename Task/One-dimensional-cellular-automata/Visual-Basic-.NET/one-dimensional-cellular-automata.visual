Imports System.Text

Module CellularAutomata

    Private Enum PetriStatus
        Active
        Stable
        Dead
    End Enum

    Function Main(ByVal cmdArgs() As String) As Integer
        If cmdArgs.Length = 0 Or cmdArgs.Length > 1 Then
            Console.WriteLine("Command requires string of either 1s and 0s or #s and _s.")
            Return 1
        End If

        Dim petriDish As BitArray

        Try
            petriDish = InitialisePetriDish(cmdArgs(0))
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Return 1
        End Try

        Dim generation As Integer = 0
        Dim ps As PetriStatus = PetriStatus.Active

        Do While True
            If ps = PetriStatus.Stable Then
                Console.WriteLine("Sample stable after {0} generations.", generation - 1)
                Exit Do
            Else
                Console.WriteLine("{0}: {1}", generation.ToString("D3"), BuildDishString(petriDish))
                If ps = PetriStatus.Dead Then
                    Console.WriteLine("Sample dead after {0} generations.", generation)
                    Exit Do
                End If
            End If

            ps = GetNextGeneration(petriDish)
            generation += 1
        Loop

        Return 0
    End Function

    Private Function InitialisePetriDish(ByVal Sample As String) As BitArray
        Dim PetriDish As New BitArray(Sample.Length)
        Dim dead As Boolean = True

        For i As Integer = 0 To Sample.Length - 1
            Select Case Sample.Substring(i, 1)
                Case "1", "#"
                    PetriDish(i) = True
                    dead = False
                Case "0", "_"
                    PetriDish(i) = False
                Case Else
                    Throw New Exception("Illegal value in string position " & i)
                    Return Nothing
            End Select
        Next

        If dead Then
            Throw New Exception("Entered sample is dead.")
            Return Nothing
        End If

        Return PetriDish
    End Function

    Private Function GetNextGeneration(ByRef PetriDish As BitArray) As PetriStatus
        Dim petriCache = New BitArray(PetriDish.Length)
        Dim neighbours As Integer
        Dim stable As Boolean = True
        Dim dead As Boolean = True

        For i As Integer = 0 To PetriDish.Length - 1
            neighbours = 0
            If i > 0 AndAlso PetriDish(i - 1) Then neighbours += 1
            If i < PetriDish.Length - 1 AndAlso PetriDish(i + 1) Then neighbours += 1

            petriCache(i) = (PetriDish(i) And neighbours = 1) OrElse (Not PetriDish(i) And neighbours = 2)
            If PetriDish(i) <> petriCache(i) Then stable = False
            If petriCache(i) Then dead = False
        Next

        PetriDish = petriCache

        If dead Then Return PetriStatus.Dead
        If stable Then Return PetriStatus.Stable
        Return PetriStatus.Active

    End Function

    Private Function BuildDishString(ByVal PetriDish As BitArray) As String
        Dim sw As New StringBuilder()
        For Each b As Boolean In PetriDish
            sw.Append(IIf(b, "#", "_"))
        Next

        Return sw.ToString()
    End Function
End Module
