{
    package Greeting;
    sub new {
        my $v = "Hello world!\n";
        bless \$v, shift;
    };
    sub stringify {
        ${shift()};
    };
};
{
    package Son::of::Greeting;
    use base qw(Greeting); # inherit methods
    sub new { # overwrite method of super class
        my $v = "Hello world from Junior!\n";
        bless \$v, shift;
    };
};
{
    use Storable qw(store retrieve);
    package main;
    my $g1 = Greeting->new;
    my $s1 = Son::of::Greeting->new;
    print $g1->stringify;
    print $s1->stringify;

    store $g1, 'objects.dat';
    my $g2 = retrieve 'objects.dat';

    store $s1, 'objects.dat';
    my $s2 = retrieve 'objects.dat';

    print $g2->stringify;
    print $s2->stringify;
};
