local(thename = web_request->param('thename')->asString)
if(#thename->size) => {^
	var(#thename = math_random)
	var(#thename)
else
	'<a href="?thename=xyz">Please give the variable a name!</a>'
^}
