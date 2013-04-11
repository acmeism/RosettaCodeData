if ($guess == 6) { print "Wow! Lucky Guess!"; };    # Traditional syntax
print 'Wow! Lucky Guess!' if $guess == 6;           # Inverted syntax (note missing braces and parens)
unless ($guess == 6) { print "Sorry, your guess was wrong!"; }   # Traditional syntax
print 'Huh! You Guessed Wrong!' unless $guess == 6;              # Inverted syntax
