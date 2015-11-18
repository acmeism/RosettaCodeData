say ++$; # this is an anonymous state variable
say ++$; # this is a different anonymous state variable, prefix:<++> forces it into numerical context and defaults it to 0
say $+=2 for 1..10 # here we do something useful with another anonymous variable

sub foo { $^a * $^b } # for positional arguments we often can't be bothered to declare them or to give them fancy names
say foo 3, 4;
