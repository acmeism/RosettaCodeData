Const adInteger = 3
Const adVarChar = 200

function charcnt(s,ch)
charcnt=0
for i=1 to len(s)
  if mid(s,i,1)=ch then charcnt=charcnt+1
next
end function

set fso=createobject("Scripting.Filesystemobject")
dim a(122)

sfn=WScript.ScriptFullName
sfn= Left(sfn, InStrRev(sfn, "\"))
set f=fso.opentextfile(sfn & "unixdict.txt",1)

'words to dictionnary using acronym as key
set d=createobject("Scripting.Dictionary")

while not f.AtEndOfStream
  erase a :cnt=0
  s=trim(f.readline)
	
	'tally chars
  for i=1 to len(s)
   n=asc(mid(s,i,1))
   a(n)=a(n)+1
  next
	
  'build the anagram
  k=""
  for i= 48 to 122
    if a(i) then k=k & string(a(i),chr(i))
  next
	
	'add to dict
  if d.exists(k) then
    b=d(k)
    d(k)=b & " " & s
  else
    d(k)=s
  end if
wend

'copy dictionnary to recorset to be able to sort it .Add nr of items as a new field
Set rs = CreateObject("ADODB.Recordset")
rs.Fields.Append "anag", adVarChar, 30
rs.Fields.Append "items", adInteger
rs.Fields.Append "words", adVarChar, 200
rs.open
for each k in d.keys
 rs.addnew
 rs("anag")=k
 s=d(k)
 rs("words")=s
 rs("items")=charcnt(s," ")+1
 rs.update
next
d.removeall

'do the query
rs.sort="items DESC, anag ASC"
rs.movefirst
it=rs("items")
while rs("items")=it
  wscript.echo  rs("items") & " (" &rs("anag") & ") " & rs("words")
  rs.movenext
wend
rs.close
