Module ArgHelper
    ReadOnly _ArgDict As New Dictionary(Of String, String)()

    Delegate Function TryParse(Of T, TResult)(value As T, <Out> ByRef result As TResult) As Boolean

    Sub InitializeArguments(args As String())
        For Each item In args
            item = item.ToUpperInvariant()

            If item.Length > 0 AndAlso item(0) <> """"c Then
                Dim colonPos = item.IndexOf(":"c, StringComparison.Ordinal)

                If colonPos <> -1 Then
                    ' Split arguments with colons into key(part before colon) / value(part after colon) pairs.
                    _ArgDict.Add(item.Substring(0, colonPos), item.Substring(colonPos + 1, item.Length - colonPos - 1))
                End If
            End If
        Next
    End Sub

    Sub FromArgument(Of T)(
            key As String,
            <Out> ByRef var As T,
            getDefault As Func(Of T),
            tryParse As TryParse(Of String, T),
            Optional validate As Predicate(Of T) = Nothing)

        Dim value As String = Nothing
        If _ArgDict.TryGetValue(key.ToUpperInvariant(), value) Then
            If Not (tryParse(value, var) AndAlso (validate Is Nothing OrElse validate(var))) Then
                Console.WriteLine($"Invalid value for {key}: {value}")
                Environment.Exit(-1)
            End If
        Else
            var = getDefault()
        End If
    End Sub
End Module
