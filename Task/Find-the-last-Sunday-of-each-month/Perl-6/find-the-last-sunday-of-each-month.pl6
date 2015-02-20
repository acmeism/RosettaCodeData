for (1..12) -> $i {
   my $lastDay = Date.days-in-month( @*ARGS[ 0 ].Int , $i ) ;
   my $lastDate = Date.new( @*ARGS[ 0 ].Int , $i , $lastDay ) ;
   while $lastDate.day-of-week != 7 {
      $lastDate -= 1 ;
   }
   $lastDate.say ;
}
