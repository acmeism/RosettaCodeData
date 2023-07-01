    '''''''''''''''''''''''''''''''''''''''''''''
    ' Rosetta Code/Rank Languages by Popularity '
    '          VBScript Implementation          '
    '...........................................'

'API Links (From C Code)
URL1 = "http://www.rosettacode.org/mw/api.php?format=json&action=query&generator=categorymembers&gcmtitle=Category:Programming%20Languages&gcmlimit=500&prop=categoryinfo&rawcontinue"
URL2 = "http://www.rosettacode.org/mw/api.php?format=json&action=query&generator=categorymembers&gcmtitle=Category:Programming%20Languages&gcmlimit=500&prop=categoryinfo&gcmcontinue="

'Get Contents of the API from the Web...
Function ScrapeGoat(link)
    On Error Resume Next
    ScrapeGoat = ""
    Err.Clear
    Set objHttp = CreateObject("Msxml2.ServerXMLHTTP")
    objHttp.Open "GET", link, False
    objHttp.Send
    If objHttp.Status = 200 And Err = 0 Then ScrapeGoat = objHttp.ResponseText
    Set objHttp = Nothing
End Function

'HACK: Setup HTML for help of my partner/competitor that is better than me, JavaScript...
Set HTML = CreateObject("HtmlFile")
Set HTMLWindow = HTML.ParentWindow


    ''''''''''''''''''''
    ' Main code begins '
    '..................'

On Error Resume Next

isComplete = 0    ' 1 -> Complete Already
cntLoop = 0       ' Counts Number of Loops Done
Set outputData = CreateObject("Scripting.Dictionary")

Do
    'Scrape Data From API
    If cntLoop = 0 Then strData = ScrapeGoat(URL1) Else strData = ScrapeGoat(URL2 & gcmCont)
    If Len(strData) = 0 Then
        Set HTML = Nothing
        WScript.StdErr.WriteLine "Processing of data stopped because API query failed."
        WScript.Quit(1)
    End If

    'Parse JSON HACK
    HTMLWindow.ExecScript "var json = " & strData, "JavaScript"
    Set ObjJS = HTMLWindow.json

    Err.Clear    'Test if Query is Complete Already
    batchCompl = ObjJS.BatchComplete
    If Err.Number = 438 Then
        'Query not yet complete. Get gcmContinue instead.
        gcmCont = ObjJS.[Query-Continue].CategoryMembers.gcmContinue
    Else
        isComplete = 1    'Yes!
    End If

    'HACK #2: Put all language page ids into a JS array to be accessed by VBScript
    HTMLWindow.ExecScript "var langs=new Array(); for(var lang in json.query.pages){langs.push(lang);}" & _
                          "var nums=langs.length;", "JavaScript"
    Set arrLangs = HTMLWindow.langs
    arrLength = HTMLWindow.nums

    For i = 0 to arrLength - 1
        BuffStr = "ObjJS.Query.Pages.[" & Eval("arrLangs.[" & i & "]") & "]"
        EachStr = Eval(BuffStr & ".title")

        Err.Clear
        CntLang =  Eval(BuffStr & ".CategoryInfo.Pages")
        If InStr(EachStr, "Category:") = 1 And Err.Number = 0 Then
            outputData.Add Replace(EachStr, "Category:", "", 1, 1), CntLang
        End If
    Next

    cntLoop = cntLoop + 1
Loop While isComplete = 0
'The outputData now contains the data we need. We should now sort and print it!

'Make a 2D array with copy of outputData
arrRelease = Array()
ReDim arrRelease(UBound(outputData.Keys), 1)

outKeys = outputData.Keys
outItem = outputData.Items
For i = 0 To UBound(outKeys)
    arrRelease(i, 0) = outKeys(i)
    arrRelease(i, 1) = outItem(i)
Next

'Bubble Sort (Greatest to Least Number of Examples)
For i = 0 to UBound(arrRelease, 1)
    For j = 0 to UBound(arrRelease, 1) - 1
        If arrRelease(j, 1) < arrRelease(j + 1, 1) Then
            temp1 = arrRelease(j + 1, 0)
            temp2 = arrRelease(j + 1, 1)
            arrRelease(j + 1, 0) = arrRelease(j, 0)
            arrRelease(j + 1, 1) = arrRelease(j, 1)
            arrRelease(j, 0) = temp1
            arrRelease(j, 1) = temp2
        End If
    Next
Next

'Save contents to file instead to support Unicode Names
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set txtOut = objFSO.CreateTextFile(".\OutVBRC.txt", True, True)

txtOut.WriteLine "As of " & Now & ", RC has " & UBound(arrRelease) + 1 & " languages."
txtOut.WriteLine ""
For i = 0 to UBound(arrRelease)
    txtOut.WriteLine arrRelease(i, 1) & " Examples - " & arrRelease(i, 0)
Next

'Successfully Done :)
Set HTML = Nothing
Set objFSO = Nothing
WScript.Quit(0)
