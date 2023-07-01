local(
 a = 'a quick brown peanut jumped over a quick brown fox',
 b = 'a quick brown'
)

//Determining if the first string starts with second string
#a->beginswith(#b) // true

//Determining if the first string contains the second string at any location
#a >> #b           // true
#a->contains(#b)   // true

//Determining if the first string ends with the second string
#a->endswith(#b)   // false
