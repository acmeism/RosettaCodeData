sub max {
     my @list = @_;
     my $themax = $list[0];
     foreach ( @list ) {
          $themax = $_ > $themax ? $_ : $themax;
     }
     return $themax;
}
