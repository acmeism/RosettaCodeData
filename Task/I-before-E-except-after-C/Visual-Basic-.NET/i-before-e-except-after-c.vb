Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Imports System.Text.RegularExpressions

#Const USE_REGEX = False

Module Program
    ' Supports both local and remote files
    Const WORDLIST_URI = "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"


    ' The support factor of a word for EI or IE is the number of occurrences that support the rule minus the number that oppose it.
    ' I.e., for IE:
    '   - increased when not preceded by C
    '   - decreased when preceded by C
    ' and for EI:
    '   - increased when preceded by C
    '   - decreased when not preceded by C
    Private Function GetSupportFactor(word As String) As (IE As Integer, EI As Integer)
        Dim IE, EI As Integer

        ' Enumerate the letter pairs in the word.
        For i = 0 To word.Length - 2
            Dim pair = word.Substring(i, 2)

            ' Instances at the beginning of a word count towards the factor and are treated as not preceded by C.
            Dim prevIsC As Boolean = i > 0 AndAlso String.Equals(word(i - 1), "c"c, StringComparison.OrdinalIgnoreCase)

            If pair.Equals("ie", StringComparison.OrdinalIgnoreCase) Then
                IE += If(Not prevIsC, 1, -1)
            ElseIf pair.Equals("ei", StringComparison.OrdinalIgnoreCase) Then
                EI += If(prevIsC, 1, -1)
            End If
        Next

        If Math.Abs(IE) > 1 Or Math.Abs(EI) > 1 Then Debug.WriteLine($"{word}: {GetSupportFactor}")
        Return (IE, EI)
    End Function


    ' Returns the number of words that support or oppose the rule.
    Private Function GetPlausabilities(words As IEnumerable(Of String)) As (ieSuppCount As Integer, ieOppCount As Integer, eiSuppCount As Integer, eiOppCount As Integer)
        Dim ieSuppCount, ieOppCount, eiSuppCount, eiOppCount As Integer

        For Each word In words
            Dim status = GetSupportFactor(word)
            If status.IE > 0 Then
                ieSuppCount += 1
            ElseIf status.IE < 0 Then
                ieOppCount += 1
            End If
            If status.EI > 0 Then
                eiSuppCount += 1
            ElseIf status.EI < 0 Then
                eiOppCount += 1
            End If
        Next

        Return (ieSuppCount, ieOppCount, eiSuppCount, eiOppCount)
    End Function


    ' Takes entire file instead of individual words.
    ' Returns the number of instances of IE or EI that support or oppose the rule.
    Private Function GetPlausabilitiesRegex(words As String) As (ieSuppCount As Integer, ieOppCount As Integer, eiSuppCount As Integer, eiOppCount As Integer)
        ' Gets number of occurrences of the pattern, case-insensitive.
        Dim count = Function(pattern As String) Regex.Matches(words, pattern, RegexOptions.IgnoreCase).Count

        Dim ie = count("[^c]ie")
        Dim ei = count("[^c]ei")
        Dim cie = count("cie")
        Dim cei = count("cei")

        Return (ie, cie, cei, ei)
    End Function


    Sub Main()
        Dim file As String
        Dim wc As New Net.WebClient()
        Try
            Console.WriteLine("Fetching file...")
            file = wc.DownloadString(WORDLIST_URI)
            Console.WriteLine("Success.")
            Console.WriteLine()
        Catch ex As Net.WebException
            Console.WriteLine(ex.Message)
            Exit Sub
        Finally
            wc.Dispose()
        End Try

#If USE_REGEX Then
        Dim res = GetPlausabilitiesRegex(file)
#Else
        Dim words = file.Split({vbCr, vbLf}, StringSplitOptions.RemoveEmptyEntries)
        Dim res = GetPlausabilities(words)
#End If

        Dim PrintResult =
        Function(suppCount As Integer, oppCount As Integer, printEI As Boolean) As Boolean
            Dim ratio = suppCount / oppCount,
                plausible = ratio > 2
#If Not USE_REGEX Then
            Console.WriteLine($"    Words with no instances of {If(printEI, "EI", "IE")} or equal numbers of supporting/opposing occurrences: {words.Length - suppCount - oppCount}")
#End If
            Console.WriteLine($"    Number supporting: {suppCount}")
            Console.WriteLine($"    Number opposing: {oppCount}")
            Console.WriteLine($"    {suppCount}/{oppCount}={ratio:N3}")
            Console.WriteLine($"    Rule therefore IS {If(plausible, "", "NOT ")}plausible.")
            Return plausible
        End Function

#If USE_REGEX Then
        Console.WriteLine($"Total occurrences of IE: {res.ieOppCount + res.ieSuppCount}")
        Console.WriteLine($"Total occurrences of EI: {res.eiOppCount + res.eiSuppCount}")
#Else
        Console.WriteLine($"Total words: {words.Length}")
#End If

        Console.WriteLine()
        Console.WriteLine("""IE is not preceded by C""")
        Dim iePlausible = PrintResult(res.ieSuppCount, res.ieOppCount, False)

        Console.WriteLine()
        Console.WriteLine("""EI is preceded by C""")
        Dim eiPlausible = PrintResult(res.eiSuppCount, res.eiOppCount, True)

        Console.WriteLine()
        Console.WriteLine($"Rule thus overall IS {If(iePlausible AndAlso eiPlausible, "", "NOT ")}plausible.")
    End Sub
End Module
