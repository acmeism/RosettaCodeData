sub max-diff (*@list) {
   return 0 if +@list < 2;
   my $max = @list.rotor(2 => -1).max({ (.[0] - .[1]).abs }).map( (* - *).abs )[0];
   "$max @ elements { @list.rotor(2 => -1).grep( { (.[0] - .[1]).abs == $max } ).gist }"
}


sub min-diff (*@list) {
   return 0 if +@list < 2;
   my $min = @list.rotor(2 => -1).min({ (.[0] - .[1]).abs }).map( (* - *).abs )[0];
   "$min @ elements { @list.rotor(2 => -1).grep( { (.[0] - .[1]).abs == $min } ).gist }"
}


sub avg-diff (*@list) { (+@list > 1) ?? (@list.sum / +@list) !! 0 }


# TESTING

for (
      [ 1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3 ]
     ,[(rand × 1e6) xx 6]
     ,[ e, i, τ, π, ∞ ]
     ,[ 1.9+3.7i, 2.07-13.2i, 0.2+-2.2i, 4.6+0i ]
     ,[ 6 ]
     ,[]
     ,[<One Two Three>]
    )
-> @list {
    say 'List: ', ~ @list.raku;
    for ('  Maximum', &max-diff ,'  Minimum', &min-diff, '  Average', &avg-diff)
    -> $which, &sub {
        say "$which distance between list elements: " ~ &sub(@list);
    }
    say '';
}
