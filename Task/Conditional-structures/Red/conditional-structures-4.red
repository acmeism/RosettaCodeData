switch "india" [
   "a"       [print "string"]
   23        [print "integer"]
   "India"   [print "The country India"]
]

The country India

switch/default "U.S." [
   "a"       [print "string"]
   23        [print "integer"]
   "India"  [print "The country India"]
][
print "no match"
]

no match
