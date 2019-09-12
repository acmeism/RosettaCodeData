Module Program
    Sub Main(args As String())
        Dim dt As Date
        Dim columns, rows, monthsPerRow As Integer
        Dim vertStretch, horizStretch, resizeWindow As Boolean

        InitializeArguments(args)
        FromArgument("date", dt, Function() New Date(1969, 1, 1), AddressOf Date.TryParse)
        FromArgument("cols", columns, Function() 80, AddressOf Integer.TryParse, Function(v) v >= 20)
        FromArgument("rows", rows, Function() 43, AddressOf Integer.TryParse, Function(v) v >= 0)
        FromArgument("ms/row", monthsPerRow, Function() 0, AddressOf Integer.TryParse, Function(v) v <= 12 AndAlso v <= columns \ 20)
        FromArgument("vstretch", vertStretch, Function() True, AddressOf Boolean.TryParse)
        FromArgument("hstretch", horizStretch, Function() True, AddressOf Boolean.TryParse)
        FromArgument("wsize", resizeWindow, Function() True, AddressOf Boolean.TryParse)

        ' The scroll bar in command prompt seems to take up part of the last column.
        If resizeWindow Then
            Console.WindowWidth = columns + 1
            Console.WindowHeight = rows
        End If

        If monthsPerRow < 1 Then monthsPerRow = Math.Max(columns \ 22, 1)

        For Each row In GetCalendarRows(dt:=dt, width:=columns, height:=rows, monthsPerRow:=monthsPerRow, vertStretch:=vertStretch, horizStretch:=horizStretch)
            Console.Write(row)
        Next
    End Sub

    Iterator Function GetCalendarRows(
            dt As Date,
            width As Integer,
            height As Integer,
            monthsPerRow As Integer,
            vertStretch As Boolean,
            horizStretch As Boolean) As IEnumerable(Of String)

        Dim year = dt.Year
        Dim calendarRowCount As Integer = CInt(Math.Ceiling(12 / monthsPerRow))
        ' Make room for the three empty lines on top.
        Dim monthGridHeight As Integer = height - 3

        Yield "[Snoopy]".PadCenter(width) & Environment.NewLine
        Yield year.ToString(CultureInfo.InvariantCulture).PadCenter(width) & Environment.NewLine
        Yield Environment.NewLine

        Dim month = 0
        Do While month < 12
            Dim rowHighestMonth = Math.Min(month + monthsPerRow, 12)

            Dim cellWidth = width \ monthsPerRow

            ' Special case when displaying only one calendar cell in a row to make 20-wide work. Adds padding between cells otherwise.
            Dim cellContentWidth = If(monthsPerRow = 1, cellWidth, (cellWidth * 19) \ 20)

            Dim cellHeight = monthGridHeight \ calendarRowCount
            Dim cellContentHeight = (cellHeight * 19) \ 20

            ' Creates a month cell for the specified month (1-12).
            Dim getMonthFrom =
                Function(m As Integer) BuildMonth(
                    dt:=New Date(dt.Year, m, 1),
                    width:=cellContentWidth,
                    height:=cellContentHeight,
                    vertStretch:=vertStretch,
                    horizStretch:=horizStretch).Select(Function(x) x.PadCenter(cellWidth))

            ' The months in this row of the calendar.
            Dim monthsThisRow As IEnumerable(Of IEnumerable(Of String)) =
                Enumerable.Select(Enumerable.Range(month + 1, rowHighestMonth - month), getMonthFrom)

            Dim calendarRow As IEnumerable(Of String) =
                Interleaved(
                    monthsThisRow,
                    useInnerSeparator:=False,
                    useOuterSeparator:=True,
                    outerSeparator:=Environment.NewLine)

            Dim en = calendarRow.GetEnumerator()
            Dim hasNext = en.MoveNext()
            Do While hasNext

                Dim current As String = en.Current

                ' To maintain the (not strictly needed) contract of yielding complete rows, keep the newline after
                ' the calendar row with the last terminal row of the row.
                hasNext = en.MoveNext()
                Yield If(hasNext, current, current & Environment.NewLine)
            Loop

            month += monthsPerRow
        Loop
    End Function

    ''' <summary>
    ''' Interleaves the elements of the specified sub-sources by making successive passes through the source
    ''' enumerable, yielding a single element from each sub-source in sequence in each pass, optionally inserting a
    ''' separator between elements of adjacent sub-sources and optionally a different separator at the end of each
    ''' pass through all the sources. (i.e., between elements of the last and first source)
    ''' </summary>
    ''' <typeparam name="T">The type of the elements of the sub-sources.</typeparam>
    ''' <param name="sources">A sequence of the sequences whose elements are to be interleaved.</param>
    ''' <param name="useInnerSeparator">Whether to insert <paramref name="useInnerSeparator"/> between the elements ofadjacent sub-sources.</param>
    ''' <param name="innerSeparator">The separator between elements of adjacent sub-sources.</param>
    ''' <param name="useOuterSeparator">Whether to insert <paramref name="outerSeparator"/> between the elements of the last and first sub-sources.</param>
    ''' <param name="outerSeparator">The separator between elements of the last and first sub-source.</param>
    ''' <param name="whileAny">If <see langword="true"/>, the enumeration continues until every given subsource is empty;
    ''' if <see langword="false"/>, the enumeration stops as soon as any enumerable no longer has an element to supply for the next pass.</param>
    Iterator Function Interleaved(Of T)(
            sources As IEnumerable(Of IEnumerable(Of T)),
            Optional useInnerSeparator As Boolean = False,
            Optional innerSeparator As T = Nothing,
            Optional useOuterSeparator As Boolean = False,
            Optional outerSeparator As T = Nothing,
            Optional whileAny As Boolean = True) As IEnumerable(Of T)
        Dim sourceEnumerators As IEnumerator(Of T)() = Nothing

        Try
            sourceEnumerators = sources.Select(Function(x) x.GetEnumerator()).ToArray()
            Dim numSources = sourceEnumerators.Length
            Dim enumeratorStates(numSources - 1) As Boolean

            Dim anyPrevIters As Boolean = False
            Do
                ' Indices of first and last sub-sources that have elements.
                Dim firstActive = -1, lastActive = -1

                ' Determine whether each sub-source that still have elements.
                For i = 0 To numSources - 1
                    enumeratorStates(i) = sourceEnumerators(i).MoveNext()
                    If enumeratorStates(i) Then
                        If firstActive = -1 Then firstActive = i
                        lastActive = i
                    End If
                Next

                ' Determine whether to yield anything in this iteration based on whether whileAny is true.
                ' Not yielding anything this iteration implies that the enumeration has ended.
                Dim thisIterHasResults As Boolean = If(whileAny, firstActive <> -1, firstActive = 0 AndAlso lastActive = numSources - 1)
                If Not thisIterHasResults Then Exit Do

                ' Don't insert a separator on the first pass.
                If anyPrevIters Then
                    If useOuterSeparator Then Yield outerSeparator
                Else
                    anyPrevIters = True
                End If

                ' Go through and yield from the sub-sources that still have elements.
                For i = 0 To numSources - 1
                    If enumeratorStates(i) Then
                        ' Don't insert a separator before the first element.
                        If i > firstActive AndAlso useInnerSeparator Then Yield innerSeparator
                        Yield sourceEnumerators(i).Current
                    End If
                Next
            Loop

        Finally
            If sourceEnumerators IsNot Nothing Then
                For Each en In sourceEnumerators
                    en.Dispose()
                Next
            End If
        End Try
    End Function

    ''' <summary>
    ''' Returns the rows representing one month cell without trailing newlines. Appropriate leading and trailing
    ''' whitespace is added so that every row has the length of width.
    ''' </summary>
    ''' <param name="dt">A date within the month to represent.</param>
    ''' <param name="width">The width of the cell.</param>
    ''' <param name="height">The height.</param>
    ''' <param name="vertStretch">If <see langword="true" />, blank rows are inserted to fit the available height.
    ''' Otherwise, the cell has a constant height of </param>
    ''' <param name="horizStretch">If <see langword="true" />, the spacing between individual days is increased to
    ''' fit the available width. Otherwise, the cell has a constant width of 20 characters and is padded to be in
    ''' the center of the expected width.</param>
    Iterator Function BuildMonth(dt As Date, width As Integer, height As Integer, vertStretch As Boolean, horizStretch As Boolean) As IEnumerable(Of String)
        Const DAY_WDT = 2 ' Width of a day.
        Const ALLDAYS_WDT = DAY_WDT * 7 ' Width of al ldays combined.

        ' Normalize the date to January 1.
        dt = New Date(dt.Year, dt.Month, 1)

        ' Horizontal whitespace between days of the week. Constant of 6 represents 6 separators per line.
        Dim daySep As New String(" "c, Math.Min((width - ALLDAYS_WDT) \ 6, If(horizStretch, Integer.MaxValue, 1)))
        ' Number of blank lines between rows.
        Dim vertblankCount = If(Not vertStretch, 0, (height - 8) \ 7)

        ' Width of each day * 7 days in one row + day separator length * 6 separators per line.
        Dim blockWidth = ALLDAYS_WDT + daySep.Length * 6

        ' The whitespace at the beginning of each line.
        Dim leftPad As New String(" "c, (width - blockWidth) \ 2)
        ' The whitespace for blank lines.
        Dim fullPad As New String(" "c, width)

        ' Lines are "staged" in the stringbuilder.
        Dim sb As New StringBuilder(leftPad)
        Dim numLines = 0

        ' Get the current line so far form the stringbuilder and begin a new line.
        ' Returns the current line and trailing blank lines used for vertical padding (if any).
        ' Returns empty enumerable if the height requirement has been reached.
        Dim EndLine =
         Function() As IEnumerable(Of String)
             Dim finishedLine As String = sb.ToString().PadRight(width)
             sb.Clear()
             sb.Append(leftPad)

             ' Use an inner iterator to prevent lazy execution of side effects of outer function.
             Return If(numLines >= height,
                 Enumerable.Empty(Of String)(),
                 Iterator Function() As IEnumerable(Of String)
                     Yield finishedLine
                     numLines += 1

                     For i = 1 To vertblankCount
                         If numLines >= height Then Return
                         Yield fullPad
                         numLines += 1
                     Next
                 End Function())
         End Function

        ' Yield the month name.
        sb.Append(PadCenter(dt.ToString("MMMM", CultureInfo.InvariantCulture), blockWidth))
        For Each l In EndLine()
            Yield l
        Next

        ' Yield the header of weekday names.
        Dim weekNmAbbrevs = [Enum].GetNames(GetType(DayOfWeek)).Select(Function(x) x.Substring(0, 2))
        sb.Append(String.Join(daySep, weekNmAbbrevs))
        For Each l In EndLine()
            Yield l
        Next

        ' Day of week of first day of month.
        Dim startWkDy = CInt(dt.DayOfWeek)

        ' Initialize with empty space for the first line.
        Dim firstPad As New String(" "c, (DAY_WDT + daySep.Length) * startWkDy)
        sb.Append(firstPad)

        Dim d = dt
        Do While d.Month = dt.Month
            sb.AppendFormat(CultureInfo.InvariantCulture, $"{{0,{DAY_WDT}}}", d.Day)

            ' Each row ends on saturday.
            If d.DayOfWeek = DayOfWeek.Saturday Then
                For Each l In EndLine()
                    Yield l
                Next
            Else
                sb.Append(daySep)
            End If

            d = d.AddDays(1)
        Loop

        ' Keep adding empty lines until the height quota is met.
        Dim nextLines As IEnumerable(Of String)
        Do
            nextLines = EndLine()
            For Each l In nextLines
                Yield l
            Next
        Loop While nextLines.Any()
    End Function

    ''' <summary>
    ''' Returns a new string that center-aligns the characters in this string by padding to the left and right with
    ''' the specified character to a specified total length.
    ''' </summary>
    ''' <param name="s">The string to center-align.</param>
    ''' <param name="totalWidth">The number of characters in the resulting string.</param>
    ''' <param name="paddingChar">The padding character.</param>
    <Extension()>
    Private Function PadCenter(s As String, totalWidth As Integer, Optional paddingChar As Char = " "c) As String
        Return s.PadLeft(((totalWidth - s.Length) \ 2) + s.Length, paddingChar).PadRight(totalWidth, paddingChar)
    End Function
End Module
