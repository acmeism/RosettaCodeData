local(
	myfile		= file('//path/to/file.txt'),
	textresult	= array
)

#myfile -> foreachline => {
	#textresult -> insert(#1)
}

#textresult -> join('<br />')
