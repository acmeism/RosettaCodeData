sub sorenson ($phrase, %hash) {
    my $match = bigram $phrase;
    %hash.race.map: { [(2 * ($match ∩ .value) / ($match + .value)).round(.001), .key] }
}

sub bigram (\these) { Bag.new( flat these.fc.words.map: { .comb.rotor(2 => -1)».join } ) }

# Load the dictionary
my %hash = './unixdict.txt'.IO.slurp.words.race.map: { $_ => .&bigram };

# Testing
for <complition inconsqual Sørenson> -> $w {
    say "\n$w:";
    .say for sorenson($w, %hash).grep(*.[0] >= .55).sort({-.[0],~.[1]}).head(10);
}
