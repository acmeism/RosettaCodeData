local(
	number1	= integer(web_request -> param('number1')),
	number2	= integer(web_request -> param('number2'))
)

#number1 < #number2 ? 'Number 1 is less than Number 2' | 'Number 1 is not less than Number 2'
'<br />'
#number1 == #number2 ? 'Number 1 is the same as Number 2' | 'Number 1 is not the same as Number 2'
'<br />'
#number1 > #number2 ? 'Number 1 is greater than Number 2' | 'Number 1 is not greater than Number 2'
