with createobject("ADODB.Stream")
  .charset ="UTF-8"
  .open
  .loadfromfile("unixdict.txt")
  s=.readtext
end with
a=split (s,vblf)

dim b(25)  'strings with lists of words
dim c(128)
'use regexp to count consonants
with new regexp
  .pattern="([^aeiou])"
  .global=true
for each i in a
  if len(trim(i))>10 then
   set matches= .execute(i)   'matches.count has the nr of consonants
   rep=false
   for each m in matches  'remove words with repeated consonants
     x=asc(m)
     c(x)=c(x)+1
     if c(x)>1 then rep=true :exit for
   next
   erase c
   if not rep then   'add item to its list
     x1=matches.count
     b(x1)=b(x1)&" "&i  'create strings of words with same nr
   end if
  end if
next
end with

'print strings with most consonants first
for i=25 to 0 step -1
  if b(i)<>"" then  wscript.echo i & "  "& b(i) & vbcrlf
next

