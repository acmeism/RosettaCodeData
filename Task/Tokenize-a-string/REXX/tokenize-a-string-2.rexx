/*REXX program to separate a string of comma-delimited words and echo */
sss='Hello,How,Are,You,Today'
say 'input string='sss
say ''
say 'Words in the string:'
ss =translate(sss,' ',',')
Do i=1 To words(ss)
  say word(ss,i)'.'
  End
say 'End-of-list.'
