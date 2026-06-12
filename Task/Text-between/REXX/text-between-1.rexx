/*REXX*/

Call test  "Hello Rosetta Code world","Hello "," world"
Call test  "Hello Rosetta Code world","start"," world"
Call test  "Hello Rosetta Code world","Hello ","end"
Call test  "</div><div style=""chinese"">???</div>","<div style=""chinese"">","</div>"
Call test  "<text>Hello <span>Rosetta Code</span> world</text><table style=""myTable"">","<text>","<table>"
Call test  "<table style=""myTable""><tr><td>hello world</td></tr></table>","<table>","</table>"
Call test  "The quick brown fox jumps over the lazy other fox","quick "," fox"
Call test  "One fish two fish red fish blue fish","fish "," red"
Call test  "FooBarBazFooBuxQuux","Foo","Foo"
Exit

test: Procedure
  Parse Arg t,s,e
  res=text_between(t,s,e)
  Call o 'Text: "'t'"'
  Call o 'Start delimiter: "'s'"'
  Call o 'End delimiter: "'e'"'
  Call o 'Output: "'res'"'
  Call o ''
  Return

text_between: Procedure
  Parse Arg this_text, start_text, end_text
  If start_text='start' Then
    rest=this_text
  Else Do
    s=pos(start_text,this_text)
    If s>0 Then
      rest=substr(this_text,s+length(start_text))
    Else
      Return ''
    End
  If end_text='end' Then
    Return rest
  Else Do
    e=pos(end_text,rest)
    If e=0 Then
      Return rest
    Return left(rest,e-1)
    End

o: Say arg(1)
