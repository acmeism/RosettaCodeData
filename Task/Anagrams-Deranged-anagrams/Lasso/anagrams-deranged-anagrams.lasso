local(
	anagrams	= map,
	words		= include_url('http://www.puzzlers.org/pub/wordlists/unixdict.txt') -> split('\n'),
	key,
	max		= 0,
	wordsize,
	findings	= array,
	derangedtest	= { // this code snippet is not executed until the variable is invoked. It will return true if the compared words are a deranged anagram
		local(
			w1		= #1,
			w2		= #2,
			testresult	= true
		)

		loop(#w1 -> size) => {
			#w1 -> get(loop_count) == #w2 -> get(loop_count) ? #testresult = false
		}
		return #testresult
	}
)

// find all anagrams
with word in #words do {
	#key = #word -> split('') -> sort& -> join('')
	not(#anagrams >> #key) ? #anagrams -> insert(#key = array)
	#anagrams -> find(#key) -> insert(#word)
}

// step thru each set of anagrams to find deranged ones
with ana in #anagrams
let ana_size = #ana -> size
where #ana_size > 1
do {
	#wordsize = #ana -> first -> size

	if(#wordsize >= #max) => {

		loop(#ana_size - 1) => {
			if(#derangedtest -> detach & invoke(#ana -> get(loop_count), #ana -> get(loop_count + 1))) => {
				// we only care to save the found deranged anagram if it is longer than the previous longest one
				if(#wordsize > #max) => {
					#findings = array(#ana -> get(loop_count) + ', ' + #ana -> get(loop_count + 1))
				else
					#findings -> insert(#ana -> get(loop_count) + ', ' + #ana -> get(loop_count + 1))
				}
				#max = #wordsize
			}
		}

	}
}

#findings -> join('<br />\n')
