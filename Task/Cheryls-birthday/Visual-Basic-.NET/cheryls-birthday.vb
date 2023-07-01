Module Module1

    Structure MonDay
        Dim month As String
        Dim day As Integer

        Sub New(m As String, d As Integer)
            month = m
            day = d
        End Sub

        Public Overrides Function ToString() As String
            Return String.Format("({0}, {1})", month, day)
        End Function
    End Structure

    Sub Main()
        Dim dates = New HashSet(Of MonDay) From {
            New MonDay("May", 15),
            New MonDay("May", 16),
            New MonDay("May", 19),
            New MonDay("June", 17),
            New MonDay("June", 18),
            New MonDay("July", 14),
            New MonDay("July", 16),
            New MonDay("August", 14),
            New MonDay("August", 15),
            New MonDay("August", 17)
        }
        Console.WriteLine("{0} remaining.", dates.Count)

        ' The month cannot have a unique day.
        Dim monthsWithUniqueDays = dates.GroupBy(Function(d) d.day).Where(Function(g) g.Count() = 1).Select(Function(g) g.First().month).ToHashSet()
        dates.RemoveWhere(Function(d) monthsWithUniqueDays.Contains(d.month))
        Console.WriteLine("{0} remaining.", dates.Count)

        ' The day must now be unique.
        dates.IntersectWith(dates.GroupBy(Function(d) d.day).Where(Function(g) g.Count() = 1).Select(Function(g) g.First()))
        Console.WriteLine("{0} remaining.", dates.Count)

        ' The month must now be unique.
        dates.IntersectWith(dates.GroupBy(Function(d) d.month).Where(Function(g) g.Count() = 1).Select(Function(g) g.First()))
        Console.WriteLine(dates.Single())
    End Sub

End Module
