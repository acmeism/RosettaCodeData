local(
	mystring	= 'Hello World',
	myarray		= array('one', 'two', 3),
	myinteger	= 1234
)

// size of a string will be a character count
#mystring -> size
'<br />'

// size of an array or map will be a count of elements
#myarray -> size
'<br />'

// elements within an array can report size
#myarray -> get(2) -> size
'<br />'

// integers or decimals does not have sizes
//#myinteger -> size // will fail
// an integer can however be converted to a string first
string(#myinteger) -> size
