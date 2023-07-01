Module Module1

    Sub Main()
        Dim word = "sos"
        Dim codes As New Dictionary(Of String, String) From {
            {"a", ".-   "}, {"b", "-... "}, {"c", "-.-. "}, {"d", "-..  "},
            {"e", ".    "}, {"f", "..-. "}, {"g", "--.  "}, {"h", ".... "},
            {"i", "..   "}, {"j", ".--- "}, {"k", "-.-  "}, {"l", ".-.. "},
            {"m", "--   "}, {"n", "-.   "}, {"o", "---  "}, {"p", ".--. "},
            {"q", "--.- "}, {"r", ".-.  "}, {"s", "...  "}, {"t", "-    "},
            {"u", "..-  "}, {"v", "...- "}, {"w", ".--  "}, {"x", "-..- "},
            {"y", "-.-- "}, {"z", "--.. "}, {"0", "-----"}, {"1", ".----"},
            {"2", "..---"}, {"3", "...--"}, {"4", "....-"}, {"5", "....."},
            {"6", "-...."}, {"7", "--..."}, {"8", "---.."}, {"9", "----."}
        }

        For Each c In word.ToCharArray
            Dim rslt = codes(c).Trim
            For Each c2 In rslt.ToCharArray
                If c2 = "." Then
                    Console.Beep(1000, 250)
                Else
                    Console.Beep(1000, 750)
                End If
                System.Threading.Thread.Sleep(50)
            Next
        Next
    End Sub

End Module
