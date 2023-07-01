sub createSubstrings( Str $word --> Array ) {
   my $length = $word.chars ;
   my @substrings ;
   for (0..$length - 1) -> $start {
      for (1..$length - $start) -> $howmany {
	 @substrings.push( $word.substr( $start , $howmany ) ) ;
      }
   }
   return @substrings ;
}

sub findLongestCommon( Str $first , Str $second --> Str ) {
   my @substringsFirst  = createSubstrings( $first ) ;
   my @substringsSecond = createSubstrings( $second ) ;
   my $firstset  = set( @substringsFirst ) ;
   my $secondset = set( @substringsSecond ) ;
   my $common = $firstset (&) $secondset ;
   return $common.keys.sort({$^b.chars <=> $^a.chars})[0] ; # or: sort(-*.chars)[0]
}

sub MAIN( Str $first , Str $second ) {
   say "The longest common substring of $first and $second is " ~
   "{findLongestCommon( $first , $second ) } !" ;
}
