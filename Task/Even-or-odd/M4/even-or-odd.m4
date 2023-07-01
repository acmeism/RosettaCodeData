define(`even', `ifelse(eval(`$1'%2),0,True,False)')
define(`odd',  `ifelse(eval(`$1'%2),0,False,True)')

even(13)
even(8)

odd(5)
odd(0)
