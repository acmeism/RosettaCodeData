# Project : Text between

text = "Hello Rosetta Code world"
startdelimiter = "Hello"
enddelimiter = "world"
textdel = []

see "Example 1. Both delimiters set :" + nl
see 'Text = "Hello Rosetta Code world"' + nl
see 'Start delimiter = "Hello"' + nl
see 'End delimiter = "world"'+ nl
see "Output = "
textarr = str2list(substr(text , " ", nl))
posstart = find(textarr, startdelimiter)
posend = find(textarr, enddelimiter)
for n = posstart + 1 to posend - 1
      add(textdel, textarr[n])
next
see '"' + substr(list2str(textdel), nl, " ") +'"' + nl + nl

see "Example 2. Start delimiter is the start of the string :" + nl
see 'Text = "Hello Rosetta Code world"' + nl
see 'Start delimiter = "start"' + nl
see 'End delimiter = "world"'+ nl
see "Output = "
textdel = []
textarr = str2list(substr(text , " ", nl))
posend = find(textarr, enddelimiter)
for n = 1 to posend - 1
      add(textdel, textarr[n])
next
see '"' + substr(list2str(textdel), nl, " ") +'"' + nl + nl

see "Example 3. End delimiter is the end of the string :" + nl
see 'Text = "Hello Rosetta Code world"' + nl
see 'Start delimiter = "Hello"' + nl
see 'End delimiter = "end"'+ nl
see "Output = "
textdel = []
textarr = str2list(substr(text , " ", nl))
posstart = find(textarr, startdelimiter)
for n = posstart + 1 to len(textarr)
      add(textdel, textarr[n])
next
see '"' + substr(list2str(textdel), nl, " ") +'"' + nl + nl
