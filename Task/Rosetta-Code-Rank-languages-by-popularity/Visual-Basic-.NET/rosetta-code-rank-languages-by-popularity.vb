Imports System.Collections
Imports System.Collections.Generic
Imports System.Net
Imports System.Text.RegularExpressions

Module RankLanguagesByPopularity

    Private Class LanguageStat
        Public name As String
        Public count As Integer
        Public Sub New(name As String, count As Integer)
            Me.name = name
            Me.count = count
        End Sub
    End Class

    Private Function CompareLanguages(x As LanguageStat, y As languageStat) As Integer
        Dim result As Integer = 0
        If x IsNot Nothing Or y IsNot Nothing Then
            If x Is Nothing Then
                result = -1
            ElseIf y Is Nothing
                result = 1
            Else
                result = - x.count.CompareTo(y.count) ' Sort descending count
                If result = 0 Then
                    result = x.name.CompareTo(y.name) ' Sort ascending  name
                End If
            End If
        End If
        Return result
    End Function

    Public Sub Main(ByVal args As String())

        Dim languages As New List(Of LanguageStat)
        Dim basePage As String = "https://rosettacode.org/wiki/Category:Programming_Languages"
        Dim nextPage As String = basePage

        Dim nextPageEx = New RegEx("<a href=""/wiki/Category:Programming_Languages([?]subcatfrom=[^""]*)""")
        Dim languageStatEx = _
            New Regex(">([^<]+?)</a>[^<]*<span title=""Contains *[0-9,.]* *[a-z]*, *([0-9,.]*) *page")

        Do While nextPage <> ""
            Dim wc As New WebClient()
            Dim page As String = wc.DownloadString(nextPage)

            nextPage = ""
            For Each link In nextPageEx.Matches(page)
                nextPage = basePage & link.Groups(1).Value
            Next link

            For Each language In languageStatEx.Matches(page)
                Dim lCount As Integer = 0
                Dim lName As String = language.Groups(1).Value
                Dim countText As String = language.Groups(2).Value.Replace(",", "").Replace(".", "")
                If Not Integer.TryParse(countText, lCount)
                    Console.Out.WriteLine(lName & "Invalid page count: <<" & countText & ">>")
                Else
                    languages.Add(New LanguageStat(lName, lCount))
                End If
            Next language
        Loop

        languages.Sort(AddressOf CompareLanguages)

        Dim prevCount As Integer = -1
        Dim prevPosition As Integer = -1
        Dim position As Integer = 0
        For Each stat As LanguageStat In languages
            position += 1
            If stat.count <> prevCount Then
                prevPosition = position
                prevCount = stat.Count
            End If
            Console.Out.WriteLine(prevPosition.ToString.PadLeft(4) & ":   " &
                                  stat.count.ToString.PadLeft(4)  & "   "  & stat.name)
        Next stat

    End Sub

End Module
