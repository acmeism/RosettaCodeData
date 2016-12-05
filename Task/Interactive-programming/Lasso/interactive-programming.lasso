#!/usr/bin/lasso9

// filename: interactive_demo

define concatenate_with_delimiter(
	string1::string,
	string2::string,
	delimiter::string

) => #string1 + (#delimiter*2) + #string2

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
	string1,
	string2,
	delimiter
)

// get first string
#string1 = read_input('Enter the first string: ')

// get second string
#string2 = read_input('Enter the second string: ')

// get delimiter
#delimiter = read_input('Enter the delimiter: ')

// deliver the result
stdoutnl(concatenate_with_delimiter(#string1, #string2, #delimiter))
