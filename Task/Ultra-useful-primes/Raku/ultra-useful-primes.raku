sub useful ($n) {
    (|$n).map: {
        my $p = 1 +< ( 1 +< $_ );
        ^$p .first: ($p - *).is-prime
    }
}

put useful 1..10;

put useful 11..13;
