sub weave ( @c ) {[
    @c.map({ $_ x 3 }),
    @c.map({ $_ ~ .trans( '#' => ' ' ) ~ $_ }),
    @c.map({ $_ x 3 }),
]}

my @carpet := ( ['#'], &weave ... * ).map: { .join: "\n" };

say @carpet[3];
