use strict;
use warnings;
use feature 'say';

my @bases = <A C G T>;

my $dna;
$dna .= $bases[int rand 4] for 1..200;

my %cnt;
$cnt{$_}++ for split //, $dna;

sub pretty {
    my($string) = @_;
    my $chunk = 10;
    my $wrap  = 5 * ($chunk+1);
    ($string =~ s/(.{$chunk})/$1 /gr) =~ s/(.{$wrap})/$1\n/gr;
}

sub mutate {
    my($dna,$count) = @_;
    my $orig = $dna;
    substr($dna,rand length $dna,1) = $bases[int rand 4] while $count > diff($orig, $dna) =~ tr/acgt//;
    $dna
}

sub diff {
    my($orig, $repl) = @_;
    for my $i (0 .. -1+length $orig) {
        substr($repl,$i,1, lc substr $repl,$i,1) if substr($orig,$i,1) ne substr($repl,$i,1);
    }
    $repl;
}

say "Original DNA strand:\n" . pretty($dna);
say "Total bases: ". length $dna;
say "$_: $cnt{$_}" for @bases;

my $mutate = mutate($dna, 10);
%cnt = ();
$cnt{$_}++ for split //, $mutate;
say "\nMutated DNA strand:\n" . pretty diff $dna, $mutate;
say "Total bases: ". length $mutate;
say "$_: $cnt{$_}" for @bases;
