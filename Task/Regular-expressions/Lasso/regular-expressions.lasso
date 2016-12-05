local(mytext = 'My name is: Stone, Rosetta
My name is: Hippo, Campus
')

local(regexp = regexp(
		-find = `(?m)^My name is: (.*?), (.*?)$`,
		-input = #mytext,
		-replace = `Hello! I am $2 $1`,
		-ignorecase
))


while(#regexp -> find) => {^
	#regexp -> groupcount > 1 ? (#regexp -> matchString(2) -> trim&) + '<br />'
^}

#regexp -> reset(-input = #mytext)
#regexp -> findall

#regexp -> reset(-input = #mytext)
'<br />'
#regexp -> replaceall
