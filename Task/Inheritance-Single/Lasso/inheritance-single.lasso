define animal => type {
	data public gender::string
}

define dog => type {
	parent animal
}

define cat => type {
	parent animal
}

define collie => type {
	parent dog
}

define lab => type {
	parent dog
}

local(myanimal = lab)

#myanimal -> gender = 'Male'
#myanimal -> gender
