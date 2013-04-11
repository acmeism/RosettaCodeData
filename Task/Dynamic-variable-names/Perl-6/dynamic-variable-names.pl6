my $vname = prompt 'Variable name: ';
$GLOBAL::($vname) = 42;
say $GLOBAL::($vname);
