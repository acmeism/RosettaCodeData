#!/usr/bin/lasso9

define read_input(prompt::string) => {

	local(string)

	// display prompt
	stdout(#prompt)
	// the following bits wait until the terminal gives you back a line of input
	while(not #string or #string -> size == 0) => {
		#string = file_stdin -> readsomebytes(1024, 1000)
	}
	#string -> replace(bytes('\n'), bytes(''))

	return #string -> asstring

}

local(
	string,
	number
)

// get string
#string = read_input('Enter the string: ')

// get number
#number = integer(read_input('Enter the number: '))

// deliver the result
stdoutnl(#string + ' (' + #string -> type + ') | ' + #number + ' (' + #number -> type + ')')
