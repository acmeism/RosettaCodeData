local(
	config		= config,
)

stdoutnl(#config -> get('FAVOURITEFRUIT'))
stdoutnl(#config -> get('SEEDSREMOVED'))
stdoutnl(#config -> get('NUMBEROFBANANAS'))

#config -> enable('seedsremoved')
#config -> enable('PARAMWITHCOMMENT', -comment = 'This param was added to demonstrate the possibility to also have comments associated with it')
#config -> disable('needspeeling')
#config -> set('numberofstrawberries', 62000)
#config -> set('numberofbananas', 1024)

#config -> write
