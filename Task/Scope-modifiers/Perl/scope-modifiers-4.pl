our $camelid = 'llama';

sub phooey
{
    print "$camelid\n";
}

phooey;                   # Prints "llama".

sub do_phooey
{
    local $camelid = 'alpaca';
    phooey;
}

do_phooey;                # Prints "alpaca".
phooey;                   # Prints "llama".
