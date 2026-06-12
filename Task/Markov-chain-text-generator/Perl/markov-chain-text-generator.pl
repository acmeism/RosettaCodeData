use strict;
use warnings;

my $file = shift || 'alice_oz.txt';
my $n    = shift || 3;
my $max  = shift || 200;

sub build_dict {
    my ($n, @words) = @_;
    my %dict;
    for my $i (0 .. $#words - $n) {
        my @prefix = @words[$i .. $i+$n-1];
        push @{$dict{join ' ', @prefix}}, $words[$i+$n];
    }
    return %dict;
}

sub pick1 { $_[rand @_] }

my $text = do {
    open my $fh, '<', $file;
    local $/;
    <$fh>;
};

my @words = split ' ', $text;
push @words, @words[0..$n-1];
my %dict  = build_dict($n, @words);
my @rotor = @words[0..$n-1];
my @chain = @rotor;

for (1 .. $max) {
    my $new = pick1(@{$dict{join ' ', @rotor}});
    shift @rotor;
    push @rotor, $new;
    push @chain, $new;
}

print join(' ', @chain) . "\n";
