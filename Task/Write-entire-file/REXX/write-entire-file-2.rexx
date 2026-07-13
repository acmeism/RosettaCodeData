/*REXX*/

of='file.txt'
'erase' of
s=copies('1234567890',10000)
Call charout of,s
Call lineout of
Say chars(of) length(s)
