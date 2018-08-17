# Project : Regular expressions

text = "I am a text"
if right(text,4) = "text"
   see "'" + text +"' ends with 'text'" + nl
ok
i = substr(text,"am")
text = left(text,i - 1) + "was" + substr(text,i + 2)
see "replace 'am' with 'was' = " + text + nl
