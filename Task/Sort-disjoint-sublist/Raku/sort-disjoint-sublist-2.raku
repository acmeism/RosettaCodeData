sub disjointSort( @values, @indices --> List ) {
   my @sortedValues = @values[ @indices ].sort ;
   for @indices.sort -> $insert {
      @values[ $insert ] = @sortedValues.shift ;
   }
   return @values ;
}

my @values = ( 7 , 6 , 5 , 4 , 3 , 2 , 1 , 0 ) ;
my @indices = ( 6 , 1 , 7 ) ;
my @sortedValues = disjointSort( @values , @indices ) ;
say @sortedValues ;
