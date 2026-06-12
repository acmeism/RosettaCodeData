my @a1 = Q:w[one two three]; # list of strings using the Q sublanguage
my @a2 = <one two three>;    # syntactic sugar for the same operation

say (1,2,3,4,5,6,7).reduce(&infix:<*>); # multiply all of the items in a list together
say [*] (1,2,3,4,5,6,7);                # same operation, sweeter syntax
