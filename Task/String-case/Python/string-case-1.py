s = "alphaBETA"
print s.upper() # => "ALPHABETA"
print s.lower() # => "alphabeta"

print s.swapcase() # => "ALPHAbeta"

print "fOo bAR".capitalize() # => "Foo bar"
print "fOo bAR".title() # => "Foo Bar"

import string
print string.capwords("fOo bAR") # => "Foo Bar"
