#!/usr/bin/lasso9

local(
	orgfilename		= $argv -> second,
	file			= file(#orgfilename),
	regexp			= regexp(-find = `(?m)$`),
	content			= #regexp -> split(-input = #file -> readstring) -> asarray,
	start			= integer($argv -> get(3) || 1),
	range			= integer($argv -> get(4) || 1)
)
stdout(#content)
#file -> copyto(#orgfilename + '.org')

fail_if(#content -> size < (#start + #range), -1, 'Not that many rows in the file')

#content -> remove(#start, #range)

#file = file(#orgfilename)
#file -> opentruncate
#file -> dowithclose => {
	#file -> writestring(#content -> join(''))
}
