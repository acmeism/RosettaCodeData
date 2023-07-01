sub carpet
{
    (['#'], -> @c {
       [
        |@c.map({$_ x 3}),
        |@c.map({ $_ ~ $_.trans('#'=>' ') ~ $_}),
        |@c.map({$_ x 3})
       ]
    } ... *).map: { .join("\n") };
}

say carpet[3];

# Same as above, structured as an array bound to a sequence, with a separate sub for clarity.
sub weave ( @c ) {
   [
    |@c.map({ $_ x 3 }),
    |@c.map({ $_ ~ .trans( '#' => ' ' ) ~ $_ }),
    |@c.map({ $_ x 3 })
   ]
}

my @carpet = ( ['#'], &weave ... * ).map: { .join: "\n" };

say @carpet[3];

# Output of both versions matches task example.
