Set http= CreateObject("WinHttp.WinHttpRequest.5.1")
Set oDic = WScript.CreateObject("scripting.dictionary")

start="https://rosettacode.org"
Const lang="VBScript"
Dim oHF

gettaskslist "about:/wiki/Category:Programming_Tasks" ,True
print odic.Count
gettaskslist "about:/wiki/Category:Draft_Programming_Tasks",True
print "total tasks " & odic.Count
gettaskslist "about:/wiki/Category:"&lang,False
print "total tasks  not in " & lang & " " &odic.Count & vbcrlf
For Each d In odic.keys
   print d &vbTab &  Replace(odic(d),"about:", start)
next
WScript.Quit(1)

Sub print(s):
  On Error Resume Next
  WScript.stdout.WriteLine (s)
  If  err= &h80070006& Then WScript.echo " Please run this script with CScript": WScript.quit
End Sub

Function getpage(name)
  Set oHF=Nothing
  Set oHF = CreateObject("HTMLFILE")
  http.open "GET",name,False  ''synchronous!
  http.send
  oHF.write "<html><body></body></html>"
  oHF.body.innerHTML = http.responsetext
  Set getpage=Nothing
End Function

Sub gettaskslist(b,build)
  nextpage=b
  While nextpage <>""

    nextpage=Replace(nextpage,"about:", start)
    WScript.Echo nextpage
    getpage(nextpage)
    Set xtoc = oHF.getElementbyId("mw-pages")
    nextpage=""
    For Each ch In xtoc.children
      If  ch.innertext= "next page" Then
        nextpage=ch.attributes("href").value
        ': WScript.Echo nextpage
      ElseIf ch.attributes("class").value="mw-content-ltr" Then
        Set ytoc=ch.children(0)
        'WScript.Echo ytoc.attributes("class").value  '"mw-category mw-category-columns"
        Exit For
      End If
    Next
    For Each ch1 In ytoc.children 'mw-category-group
      'WScript.Echo ">" &ch1.children(0).innertext &"<"
      For Each ch2 In ch1.children(1).children '"mw_category_group".ul
        Set ch=ch2.children(0)
        If build Then
           odic.Add ch.innertext , ch.attributes("href").value
        else
           if odic.exists(ch.innertext) then odic.Remove ch.innertext
        End if
           'WScript.Echo ch.innertext , ch.attributes("href").value
      Next
    Next
  Wend
End Sub
