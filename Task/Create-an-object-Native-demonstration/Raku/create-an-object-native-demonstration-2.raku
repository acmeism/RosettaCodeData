class Magic {
        has %.hash;
        multi method FALLBACK($name, |c) is rw { # this will eat any extra parameters
                %.hash{$name}
        }

        multi method FALLBACK($name) is rw {
                %.hash{$name}
        }
}

my $magic = Magic.new;
$magic.foo = 10;
say $magic.foo;
$magic.defined = False; # error
