my $languages =  qx{wget -O - 'http://rosettacode.org/wiki/Category:Programming_Languages'};
my $categories = qx{wget -O - 'http://www.rosettacode.org/mw/index.php?title=Special:Categories&limit=5000'};

my @lines = $languages.lines;
shift @lines until @lines[0] ~~ / '<h2>Subcategories</h2>' /;
my \languages = set gather for @lines {
    last if / '/bodycontent' /;
    take ~$0 if
        / '<li><a href="/wiki/Category:' .*? '" title="Category:' .*? '">' (.*?) '</a></li>' /;
}

@lines = $categories.lines;
my @results = sort -*.[0], gather for @lines {
    take [+$1.subst(',', ''), ~$0] if
        / '<li><a href="/wiki/Category:' .*? '" title="Category:' .*? '">'
        (.*?) <?{ ~$0 ∈ languages }>
        '</a>' .*? '(' (<[, 0..9]>+) ' member' /;
}

for @results.kv -> $i, @l {
    printf "%d:\t%4d - %s\n", $i+1, |@l;
}
