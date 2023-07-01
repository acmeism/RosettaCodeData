def sigma( stream ): reduce stream as $x (0; . + $x ) ;

def ismunchausen:
   def digits: tostring | split("")[] | tonumber;
   . == sigma(digits | pow(.;.));

# Munchausen numbers from 1 to 5000 inclusive:
range(1;5001) | select(ismunchausen)
