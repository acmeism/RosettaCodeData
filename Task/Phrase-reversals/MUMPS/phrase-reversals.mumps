set string="Rosetta Code Phrase Reversal"
set str="",len=$length(string," ")
for i=1:1:len set $piece(str," ",i)=$piece(string," ",len-i+1)
write string,!
write $reverse(string),!
write str,!
write $reverse(str),!
