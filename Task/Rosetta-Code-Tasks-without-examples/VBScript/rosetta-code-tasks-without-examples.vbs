Option Explicit

Dim oIE : Set oIE = CreateObject("InternetExplorer.Application")

Dim oFSO : Set oFSO = CreateObject("Scripting.FileSystemObject")

Dim oRE : Set oRE = New RegExp
oRE.Pattern = "class=[" & Chr(34) & "'](.*?)[" & Chr(34) & "']"
oRE.IgnoreCase = True

oIE.Navigate "http://rosettacode.org/wiki/Category:Programming_Tasks"
While oIE.Busy
	WScript.Sleep 100
Wend

Dim oDoc : Set oDoc = oIE.Document
Dim oDict : Set oDict = CreateObject("Scripting.Dictionary")

' build a dictionary of anchors
Dim oAnchor
Dim oAnchors : Set oAnchors = oDoc.getElementById("mw-pages").getElementsByTagName("a")
For Each oAnchor In oAnchors
	oDict.Add oAnchor.innerText, oAnchor.href
Next

'traverse the dictionary of anchors
Dim aKeys : aKeys = oDict.Keys()
Dim aKey
For Each aKey In aKeys
	Slurp aKey, oDict(aKey)
Next

oIE.Quit

Function Slurp(sTitle, sHref)
	WScript.Echo sTitle, sHref
	
	oIE.Navigate sHref
	While oIE.Busy
		WScript.Sleep 100
	Wend
	
	Dim oDoc : Set oDoc = oIE.Document
	
	Dim oStart : Set oStart = oDoc.getElementsByClassName("infobox")(0)
	Dim oCursor : Set oCursor = oStart
	Dim sDescription : sDescription = vbNullString
	Dim oThere
	Dim iErr
	
	Do While oCursor.tagName <> "TABLE" And oCursor.id <> "toc"
		Set oThere = oCursor
		sDescription = sDescription & oThere.innerHTML & vbNewLine
		On Error Resume Next
		Set oCursor = oCursor.nextElementSibling
		iErr = Err.Number
		On Error Goto 0
		If iErr <> 0 Then
			Exit Do
		End If
	Loop
	
	dim sTitle2
	sTitle2 = Replace(sTitle,"/","_")
	sTitle2 = Replace(sTitle2,Chr(34),"'")
	sTitle2 = Replace(sTitle2,"*",".")
	
	Dim oHandle : Set oHandle = oFSO.CreateTextFile(sTitle2 & ".htm", True, True)
	oHandle.Write "<a href='" & sHref & "'>" & sTitle & "</a><br><br>"
	oHandle.Write sDescription
	oHandle.Close
	
	oIE.Stop

End Function
