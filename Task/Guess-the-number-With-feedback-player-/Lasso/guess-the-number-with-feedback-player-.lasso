#!/usr/bin/lasso9

local(
	mini=0,
	maxi=100,
	status	= false,
	count = 0,
	response,
	guess
)

stdoutnl('Think of a number between ' + #mini + ' and ' + #maxi + '
Each time I guess indicate if I was to high (H), to low (L) or just right (R).')


while(not #status) => {

	if(not(#mini <= #maxi)) => {

		stdout('I think you are trying to cheat me. I will not play anymore.')
		#status = true

	else

		#guess = ((#maxi - #mini) /2 ) + #mini

		stdout('You are thinking on ' + #guess + ' ')
		#response = null

		// the following bits wait until the terminal gives you back a line of input
		while(not #response or #response -> size == 0) => {
			#response = file_stdin -> readSomeBytes(1024, 1000)
		}
		#response -> replace(bytes('\n'), bytes(''))

		match(string(#response)) => {
			case('L')
				#mini = #guess + 1
				#count++
			case('H')
				#maxi = #guess - 1
				#count++
			case('R')
				stdout('Am I smart or smart! I guessed it in ' + #count ' tries!')
				#status = true
			case()
				stdout('Are you having issues reading instructions? ')
		}
	}
}
