sub carpet
{
    (['#'], -> @c {
        [ @c.map({$_ x 3}),
        @c.map({ $_ ~ $_.trans('#'=>' ') ~ $_}),
        @c.map({$_ x 3}) ]
    } ... *).map: { .join("\n") };
}

say carpet[3];
