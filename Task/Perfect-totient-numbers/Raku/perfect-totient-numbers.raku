use Prime::Factor;

my \𝜑 = lazy 0, |(1..*).hyper.map: -> \t { t * [*] t.&prime-factors.squish.map: 1 - 1/* }
my \𝜑𝜑 = Nil, |(3, *+2 … *).grep: -> \p { p == sum 𝜑[p], { 𝜑[$_] } … 1 };

put "The first twenty Perfect totient numbers:\n",  𝜑𝜑[1..20];
