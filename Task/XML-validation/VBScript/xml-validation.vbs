Option explicit

Function fileexists(fn)
  fileexists= CreateObject("Scripting.FileSystemObject").FileExists(fn)
End Function

Function xmlvalid(strfilename)
  Dim xmldoc,xmldoc2,objSchemas
  Set xmlDoc = CreateObject("Msxml2.DOMDocument.6.0")

  If fileexists(Replace(strfilename,".xml",".dtd")) Then
    xmlDoc.setProperty "ProhibitDTD", False
    xmlDoc.setProperty "ResolveExternals", True
    xmlDoc.validateOnParse = True
    xmlDoc.async = False
    xmlDoc.load(strFileName)
  ElseIf fileexists(Replace(strfilename,".xml",".xsd")) Then
    xmlDoc.setProperty "ProhibitDTD", True
    xmlDoc.setProperty "ResolveExternals", True
    xmlDoc.validateOnParse = True
    xmlDoc.async = False
    xmlDoc.load(strFileName)

    'import xsd
    Set xmlDoc2 = CreateObject("Msxml2.DOMDocument.6.0")
    xmlDoc2.validateOnParse = True
    xmlDoc2.async = False
    xmlDoc2.load(Replace (strfilename,".xml",".xsd"))

    'cache xsd
    Set objSchemas = CreateObject("MSXML2.XMLSchemaCache.6.0")
    objSchemas.Add "", xmlDoc2
  Else
    Set xmlvalid= Nothing:Exit Function
  End If

  Set xmlvalid=xmldoc.parseError
End Function



Sub displayerror (parserr) 'display the info returned by Msxml2
  Dim strresult
  If parserr is Nothing Then
    strresult= "could not find dtd or xsd for " & strFileName
  Else
    With parserr
     Select Case .errorcode
      Case 0
        strResult = "Valid: " & strFileName & vbCr
      Case Else
        strResult = vbCrLf & "ERROR! Failed to validate " & _
        strFileName & vbCrLf &.reason & vbCr & _
        "Error code: " & .errorCode & ", Line: " & _
        .line & ", Character: " & _
        .linepos & ", Source: """ & _
        .srcText &  """ - " & vbCrLf

      End Select
    End With
  End If
  WScript.Echo strresult
End Sub

'main
Dim strfilename

'testing validation with dtd
'strfilename="books.xml"
'displayerror xmlvalid (strfilename)

'testing validation with xsd
strfilename="shiporder.xml"
displayerror xmlvalid (strfilename)
