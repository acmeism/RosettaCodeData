local(dogs = map(
	bytes('dog') = 'Benjamin',
	bytes('Dog') = 'Samba',
	bytes('DOG') = 'Bernie'
))

stdoutnl(#dogs -> size)

stdoutnl(#dogs -> find(bytes('Dog')))
