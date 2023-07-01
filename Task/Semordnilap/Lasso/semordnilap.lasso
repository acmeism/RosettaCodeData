local(
	words		= string(include_url('http://www.puzzlers.org/pub/wordlists/unixdict.txt')) -> split('\n'),
	semordnilaps	= array,
	found_size,
	example,
	haveexamples	= false,
	examples	= array
)

#words -> removeall('')

with word in #words do {
	local(reversed = string(#word) -> reverse&)
	if(not(#word == #reversed) and not(#semordnilaps >> #word) and not(#semordnilaps >> #reversed) and #words >> #reversed) => {
		#semordnilaps -> insert(#word = #reversed)
	}
}

#found_size = #semordnilaps -> size

while(not(#haveexamples)) => {
	#example = #semordnilaps -> get(integer_random(#found_size, 1))
	not(#examples >> #example -> name) ? #examples -> insert(#example)
	#examples -> size >= 5 ? #haveexamples = true
}
'Total found: '
#found_size
'<br />'
#examples
