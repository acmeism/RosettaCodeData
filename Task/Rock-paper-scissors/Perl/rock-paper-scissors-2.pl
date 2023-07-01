perl -e '@c=qw(r p s); for(1..10000){ print $c[ rand() < 0.75 ? 0 : int rand(2) + 1 ], "\n" }' | perl rps.pl --quiet
