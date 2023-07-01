text='Hello,How,Are,You,Today'
do while text \= ''
   parse var text word1 ',' text
   call charout 'STDOUT:',word1'.'
end
