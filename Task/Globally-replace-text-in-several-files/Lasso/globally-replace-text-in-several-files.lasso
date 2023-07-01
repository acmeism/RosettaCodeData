#!/usr/bin/lasso9

local(files = array('f1.txt', 'f2.txt'))

with filename in #files
let file = file(#filename)
let content = #file -> readbytes
do {
	#file -> dowithclose => {
		#content -> replace('Goodbye London!', 'Hello New York!')
		#file -> opentruncate
		#file -> writebytes(#content)
	}
}
