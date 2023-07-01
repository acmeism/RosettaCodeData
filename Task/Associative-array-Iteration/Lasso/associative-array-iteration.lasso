//iterate over associative array
//Lasso maps
	local('aMap' = map('weight' = 112,
					'height' = 45,
					'name' = 'jason'))
	' Map output: \n  '
	#aMap->forEachPair => {^
		//display pair, then show accessing key and value individually
		#1+'\n  '
		#1->first+': '+#1->second+'\n  '
	^}
	//display keys and values separately
	'\n'
	' Map Keys: '+#aMap->keys->join(',')+'\n'
	' Map values: '+#aMap->values->join(',')+'\n'
	
	//display using forEach
	'\n'
	' Use ForEach to iterate Map keys: \n'
	#aMap->keys->forEach => {^
		#1+'\n'	
	^}
	'\n'
	' Use ForEach to iterate Map values: \n'
	#aMap->values->forEach => {^
		#1+'\n'	
	^}
	//the {^ ^} indicates that output should be printed (AutoCollect) ,
	// if output is not desired, just { } is used
