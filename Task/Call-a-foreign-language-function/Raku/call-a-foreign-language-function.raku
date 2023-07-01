use NativeCall;

sub strdup(Str $s --> Pointer) is native {*}
sub puts(Pointer $p --> int32) is native {*}
sub free(Pointer $p --> int32) is native {*}

my $p = strdup("Success!");
say 'puts returns ', puts($p);
say 'free returns ', free($p);
