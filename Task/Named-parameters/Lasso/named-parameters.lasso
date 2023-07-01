define mymethod(
	-first::integer, // with no default value the param is required
	-second::integer,
	-delimiter::string = ':' // when given a default value the param becomes optional
) => #first + #delimiter + #second

mymethod(
	-first = 54,
	-second = 45
)
'<br />'
mymethod(
	-second = 45, // named params can be given in any order
	-first = 54,
	-delimiter = '#'
)
