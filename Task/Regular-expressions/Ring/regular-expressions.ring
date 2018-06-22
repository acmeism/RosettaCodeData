# Project : Regular expressions
# Date    : 2018/01/23
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

text = "I am a text"
if right(text,4) = "text"
   see "'" + text +"' ends with 'text'" + nl
ok
i = substr(text,"am")
text = left(text,i - 1) + "was" + substr(text,i + 2)
see "replace 'am' with 'was' = " + text + nl
