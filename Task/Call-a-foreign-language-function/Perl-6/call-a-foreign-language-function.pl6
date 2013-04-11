use NativeCall;

sub strdup(Str $s --> OpaquePointer) is native {*}
sub puts(OpaquePointer $p --> int) is native {*}
sub free(OpaquePointer $p --> int) is native {*}

my $p = strdup("Success!");
say 'puts returns ', puts($p);
say 'free returns ', free($p);
