for './nonogram_problems.txt'.IO.lines.rotor(3, :partial) {

   my (@rpats,@cpats) := @_[0,1]>>.&makepatterns;
   my @rows            = ( '.' x +@cpats ) xx +@rpats ;

   loop (my $prev = ''; $prev ne ~@rows; ) {
      $prev = ~@rows;
      try(@rows, @rpats);
      my @cols = (^+@cpats).map: { [~] @rows.map: { ~ s/.// } }
      try(@cols, @cpats);
      @rows    = (^+@rpats).map: { [~] @cols.map: { ~ s/.// } }
   }
   say();
   @rows ~~ /\./ ?? say "Failed" !! say TR/01/.@/ for @rows
}

sub try(@lines, @patterns) {
   for ^+@lines -> $i {
      my $pos = 0;
      while ( @lines[$i] ~~ m:g/\./ and $pos < @lines[$i].chars ) {
         for 0, 1 -> $try {
	    with @lines[$i] { S:pos($pos)/\./$try/ ~~ /<{@patterns[$i]}>/ or
                              s:pos($pos)/./{ 1 - $try }/                   }
         }
	 $pos++;
      }
   }
}

sub makepatterns($input) {
   $input ==> split( ' ' )
          ==>   map( *.comb )
	  ==>   map( *>>.&{ .ord - 64 } )
	  ==>   map( '<[1.]>**' <<~<< * )
	  ==>   map( *.join:  '<[0.]>+' )
	  ==>   map( '^<[0.]>*' ~ * ~ '<[0.]>*$' )
}
