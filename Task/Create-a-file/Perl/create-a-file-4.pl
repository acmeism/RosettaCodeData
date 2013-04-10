for my $prefix (qw( ./ / )) {
   mkdir "${prefix}docs";
   open my $FH, '>', "${prefix}docs/output.txt";
}
