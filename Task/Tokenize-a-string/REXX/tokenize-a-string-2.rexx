/*REXX program to separate a string of comma-delimited words and echo */
sss='Hello,How,Are,You,Today'
say 'input string='sss
say ''
say 'Words in the string:'
ss =translate(sss,' ',',')
dot='.'
Do i=1 To words(ss)
  If i=words(ss) Then dot=''
  say word(ss,i)dot
  End
say 'End-of-list.'
