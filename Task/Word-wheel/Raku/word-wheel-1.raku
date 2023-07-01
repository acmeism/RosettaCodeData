use Terminal::Boxer;

my %*SUB-MAIN-OPTS = :named-anywhere;

unit sub MAIN ($wheel = 'ndeokgelw', :$dict = './unixdict.txt', :$min = 3);

my $must-have = $wheel.comb[4].lc;

my $has = $wheel.comb».lc.Bag;

my %words;
$dict.IO.slurp.words».lc.map: {
    next if not .contains($must-have) or .chars < $min;
    %words{.chars}.push: $_ if .comb.Bag ⊆ $has;
};

say "Using $dict, minimum $min letters.";

print rs-box :3col, :3cw, :indent("\t"), $wheel.comb».uc;

say "{sum %words.values».elems} words found";

printf "%d letters:  %s\n", .key, .value.sort.join(', ') for %words.sort;
