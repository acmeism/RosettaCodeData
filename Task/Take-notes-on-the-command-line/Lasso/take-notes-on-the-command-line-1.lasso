#!/usr/bin/lasso9

local(
	arguments	= $argv -> asarray,
	notesfile	= file('notes.txt')
)

#arguments -> removefirst

if(#arguments -> size) => {

	#notesfile -> openappend
	#notesfile -> dowithclose => {
		#notesfile -> writestring(date -> format(`YYYY-MM-dd HH:mm:SS`) + '\n')
		#notesfile -> writestring('\t' + #arguments -> join(', ') + '\n')
	}



else
	#notesfile -> exists ? stdout(#notesfile -> readstring)
}
