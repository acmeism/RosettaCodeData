local(
	str 	= 'Hello world!',
	freq	= map
)
// as a loop. arguably quicker than query expression
loop(#str->size) => {
	#freq->keys !>> #str->get(loop_count) ?
		#freq->insert(#str->get(loop_count) = #str->values->find(#str->get(loop_count))->size)
}

// or
local(
	str 	= 'Hello world!',
	freq	= map
)
// as query expression, less code
with i in #str->values where #freq->keys !>> #i do => {
	#freq->insert(#i = #str->values->find(#i)->size)
}

// output #freq
with elem in #freq->keys do => {^
	'"'+#elem+'": '+#freq->find(#elem)+'\r'
^}
