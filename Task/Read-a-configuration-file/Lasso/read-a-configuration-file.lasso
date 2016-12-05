local(config = '# This is a configuration file in standard configuration file format
#
# Lines beginning with a hash or a semicolon are ignored by the application
# program. Blank lines are also ignored by the application program.

# This is the fullname parameter

FULLNAME Foo Barber

# This is a favourite fruit
FAVOURITEFRUIT = banana

# This is a boolean that should be set
NEEDSPEELING

# This boolean is commented out
; SEEDSREMOVED

# Configuration option names are not case sensitive, but configuration parameter
# data is case sensitive and may be preserved by the application program.

# An optional equals sign can be used to separate configuration parameter data
# from the option name. This is dropped by the parser.

# A configuration option may take multiple parameters separated by commas.
# Leading and trailing whitespace around parameter names and parameter data fields
# are ignored by the application program.

OTHERFAMILY Rhu Barber, Harry Barber
')
// if config is in a file collect it like this
//local(config = file('path/and/file.name') -> readstring)

define getconfig(term::string, config::string) => {

	local(
		regexp	= regexp(-find = `(?m)^` + #term + `($|\s*=\s*|\s+)(.*)$`, -input = #config, -ignorecase),
		result
	)

	while(#regexp -> find) => {
		#result = (#regexp -> groupcount > 1 ? (#regexp -> matchString(2) -> trim& || true))
		if(#result -> asstring >> ',') => {
			#result = #result -> split(',')
			#result -> foreach => {#1 -> trim}
		}
		return #result
	}
	return false

}

local(
	fullname	= getconfig('FULLNAME', #config),
	favorite	= getconfig('FAVOURITEFRUIT', #config),
	sedsremoved	= getconfig('SEEDSREMOVED', #config),
	needspeel	= getconfig('NEEDSPEELING', #config),
	otherfamily	= getconfig('OTHERFAMILY', #config)
)

#fullname
'<br />'
#favorite
'<br />'
#sedsremoved
'<br />'
#needspeel
'<br />'
#otherfamily
'<br />'
