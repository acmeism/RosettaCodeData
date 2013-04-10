#!/usr/bin/perl -w

my $verse = <<"VERSE";
100 bottles of beer on the wall,
100 bottles of beer!
Take one down, pass it around!
99 bottles of beer on the wall!

VERSE

{
    $verse =~ s/(\d+)/$1-1/ge;
    $verse =~ s/\b1 bottles/1 bottle/g;
    my $done = $verse =~ s/\b0 bottle/No bottles/g; # if we make this replacement, we're also done.

    print $verse;
    redo unless $done;
}
