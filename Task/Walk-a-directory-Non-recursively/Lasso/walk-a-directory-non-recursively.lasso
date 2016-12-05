local(matchingfilenames = array)

dir('.') -> foreach => {#1 >> 'string' ? #matchingfilenames -> insert(#1)}

#matchingfilenames
