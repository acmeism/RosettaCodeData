set stringA to "I felt happy because I saw the others were happy and because I knew I should feel happy, but I wasn’t really happy."

set string1 to "I felt happy"
set string2 to "I should feel happy"
set string3 to "I wasn't really happy"

-- Determining if the first string starts with second string
stringA starts with string1  --> true

-- Determining if the first string contains the second string at any location
stringA contains string2     --> true

-- Determining if the first string ends with the second string
stringA ends with string3    --> false

-- Print the location of the match for part 2
offset of string2 in stringA --> 69
