my @values  = 7, 6, 5, 4, 3, 2, 1, 0;
my @indices = 6, 1, 7;

@values[ @indices.sort ] .= sort;

@values.perl.say;
