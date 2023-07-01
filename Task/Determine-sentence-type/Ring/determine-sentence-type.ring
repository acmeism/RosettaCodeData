see "working..." + nl
sType = []
sent = "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! How do you like this washing machine? Buy it, don't hesitate! You will be satisfied with it. Just make sure you don't break it"

ind = 1
while true
      pos = substring(sent,"?",ind)
      if pos > 0
         add(sType,pos)
         ind = pos+1
      else
         exit
      ok
end

ind = 1
while true
      pos = substring(sent,"!",ind)
      if pos > 0
         add(sType,pos)
         ind = pos+1
      else
         exit
      ok
end

ind = 1
while true
      pos = substring(sent,".",ind)
      if pos > 0
         add(sType,pos)
         ind = pos+1
      else
         exit
      ok
end

if pos < len(sent)
   neut = "N"
else
   neut = ""
ok

sType = sort(sType)

text = ""
for n = 1 to len(sType)
    if sent[sType[n]] = "?"
       text = text + "Q" + "|"
    ok
    if sent[sType[n]] = "!"
       text = text + "E" + "|"
    ok
    if sent[sType[n]] = "."
       text = text + "S" + "|"
    ok
next
see text + neut  + nl
see "done..." + nl

func substring str,substr,n
	newstr=right(str,len(str)-n+1)
	nr = substr(newstr, substr)
	if nr = 0
		return 0
	else
		return n + nr -1
	ok
