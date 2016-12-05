local(
	anagrams	= map,
	words		= include_url('http://www.puzzlers.org/pub/wordlists/unixdict.txt')->split('\n'),
	key,
	max		= 0,
	findings	= array
)

with word in #words do {
	#key = #word -> split('') -> sort& -> join('')
	if(not(#anagrams >> #key)) => {
		#anagrams -> insert(#key = array)
	}
	#anagrams -> find(#key) -> insert(#word)
}
with ana in #anagrams
let ana_size = #ana -> size
do {
	if(#ana_size > #max) => {
		#findings = array(#ana -> join(', '))
		#max = #ana_size
	else(#ana_size == #max)
		#findings -> insert(#ana -> join(', '))
	}
}

#findings -> join('<br />\n')
