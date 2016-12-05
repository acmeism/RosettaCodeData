sub funkshun ($a, $b?, :$c = 15, :$d, *@e, *%f) {
   say "$a $b $c $d";
   say join ' ', @e;
   say join ' ', keys %f;
}
