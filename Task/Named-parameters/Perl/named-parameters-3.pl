sub event
{
    my ($params_ref, $name) = @_;
    my %params = %$params_ref;
    my @known_params = qw(attendees event food time);

    printf "%s called event() with the following named parameters:\n",
        $name // 'Anonymous';

    say sort map {
        sprintf "%s: %s\n",
            ucfirst $_,
            ref $params{$_} eq ref []
            ? join ', ', @{ $params{$_} }
            : $params{$_};
    } grep exists $params{$_}, @known_params;
    delete $params{$_} foreach @known_params;

    say "But I didn't recognize these ones:";
    while (my ($key, $val) = each %params)
    {
        say "$key: $val";
    }
}

event(
    {   # Curly braces with no label (e.g. 'sub' before it)
        # create a reference to an anonymous hash
        attendees => ['Bob', 'Betty', 'George', 'Bertha'],
        event     => 'birthday',
        foo       => 'bar',
        food      => 'cake',
        frogblast => 'vent core',
        time      => 3,
    },
    "Joe Schmoe"
);
