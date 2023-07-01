Module Module1
    ''' <summary>
    ''' wide - Widens the aspect ratio of a linefeed separated string.
    ''' </summary>
    ''' <param name="src">A string representing a block of towers.</param>
    ''' <param name="margin">Optional padding for area to the left.</param>
    ''' <returns>A double-wide version of the string.</returns>
    Function wide(src As String, Optional margin As String = "") As String
        Dim res As String = margin : For Each ch As Char In src
            res += If(ch < " ", ch & margin, ch + ch) : Next : Return res
    End Function

    ''' <summary>
    ''' cntChar - Counts characters, also custom formats the output.
    ''' </summary>
    ''' <param name="src">The string to count characters in.</param>
    ''' <param name="ch">The character to be counted.</param>
    ''' <param name="verb">Verb to include in format.  Expecting "hold",
    '''             but can work with "retain" or "have".</param>
    ''' <returns>The count of chars found in a string, and formats a verb.</returns>
    Function cntChar(src As String, ch As Char, verb As String) As String
        Dim cnt As Integer = 0
        For Each c As Char In src : cnt += If(c = ch, 1, 0) : Next
        Return If(cnt = 0, "does not " & verb & " any",
            verb.Substring(0, If(verb = "have", 2, 4)) & "s " & cnt.ToString())
    End Function

    ''' <summary>
    ''' report - Produces a report of the number of rain units found in
    '''          a block of towers, optionally showing the towers.
    '''          Autoincrements the blkID for each report.
    ''' </summary>
    ''' <param name="tea">An int array with tower elevations.</param>
    ''' <param name="blkID">An int of the block of towers ID.</param>
    ''' <param name="verb">The verb to use in the description.
    '''                    Defaults to "has / have".</param>
    ''' <param name="showIt">When true, the report includes a string representation
    '''                      of the block of towers.</param>
    ''' <returns>A string containing the amount of rain units, optionally preceeded by
    '''          a string representation of the towers holding any water.</returns>
    Function report(tea As Integer(),                             ' Tower elevation array.
                    ByRef blkID As Integer,                ' Block ID for the description.
                    Optional verb As String = "have",    ' Verb to use in the description.
                    Optional showIt As Boolean = False) As String    ' Show representaion.
        Dim block As String = "",                                   ' The block of towers.
            lf As String = vbLf,                           ' The separator between floors.
            rTwrPos As Integer        ' The position of the rightmost tower of this floor.
        Do
            For rTwrPos = tea.Length - 1 To 0 Step -1      ' Determine the rightmost tower
                If tea(rTwrPos) > 0 Then Exit For          '      postition on this floor.
            Next
            If rTwrPos < 0 Then Exit Do         ' When no towers remain, exit the do loop.
            ' init the floor to a space filled Char array, as wide as the block of towers.
            Dim floor As Char() = New String(" ", tea.Length).ToCharArray()
            Dim bpf As Integer = 0                  ' The count of blocks found per floor.
            For column As Integer = 0 To rTwrPos                ' Scan from left to right.
                If tea(column) > 0 Then                     ' If a tower exists here,
                    floor(column) = "█"                     ' mark the floor with a block,
                    tea(column) -= 1                    ' drop the tower elevation by one,
                    bpf += 1                           ' and advance the block count.
                ElseIf bpf > 0 Then    ' Otherwise, see if a tower is present to the left.
                    floor(column) = "≈"                           ' OK to fill with water.
                End If
            Next
            If bpf > If(showIt, 0, 1) Then       ' Continue the building only when needed.
                ' If not showing blocks, discontinue building when a single tower remains.
                ' build tower blocks string with each floor added to top.
                block = New String(floor) & If(block = "", "", lf) & block
            Else
                Exit Do                          ' Ran out of towers, so exit the do loop.
            End If
        Loop While True ' Depending on previous break statements to terminate the do loop.
        blkID += 1                                           ' increment block ID counter.
        ' format report and return it.
        Return If(showIt, String.Format(vbLf & "{0}", wide(block, "   ")), "") &
            String.Format(" Block {0} {1} water units.", blkID, cntChar(block, "≈", verb))
    End Function

    ''' <summary>
    ''' Main routine.
    '''
    ''' With one command line parameter, it shows tower blocks,
    '''  with no command line parameters, it shows a plain report
    '''</summary>
    Sub Main()
        Dim shoTow As Boolean = Environment.GetCommandLineArgs().Count > 1  ' Show towers.
        Dim blkCntr As Integer = 0        ' Block ID for reports.
        Dim verb As String = "hold"    ' "retain" or "have" can be used instead of "hold".
        Dim tea As Integer()() = {New Integer() {1, 5, 3, 7, 2},   ' Tower elevation data.
            New Integer() {5, 3, 7, 2, 6, 4, 5, 9, 1, 2},
            New Integer() {2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1},
            New Integer() {5, 5, 5, 5}, New Integer() {5, 6, 7, 8},
            New Integer() {8, 7, 7, 6}, New Integer() {6, 7, 10, 7, 6}}
        For Each block As Integer() In tea
            ' Produce report for each block of towers.
            Console.WriteLine(report(block, blkCntr, verb, shoTow))
        Next
    End Sub
End Module
