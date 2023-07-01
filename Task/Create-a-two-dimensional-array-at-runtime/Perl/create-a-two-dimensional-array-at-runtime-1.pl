sub make_array($ $){
  # get array sizes from provided params, but force numeric value
  my $x = ($_[0] =~ /^\d+$/) ? shift : 0;
  my $y = ($_[0] =~ /^\d+$/) ? shift : 0;

  # define array, then add multi-dimensional elements
  my @array;
  $array[0][0] = 'X '; # first by first element
  $array[5][7] = 'X ' if (5 <= $y and 7 <= $x); # sixth by eighth element, if the max size is big enough
  $array[12][15] = 'X ' if (12 <= $y and 15 <= $x); # thirteenth by sixteenth element, if the max size is big enough

  # loop through the elements expected to exist base on input, and display the elements contents in a grid
  foreach my $dy (0 .. $y){
    foreach my $dx (0 .. $x){
      (defined $array[$dy][$dx]) ? (print $array[$dy][$dx]) : (print '. ');
    }
    print "\n";
  }
}
