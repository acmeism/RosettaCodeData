shell "wget -O languages.html 'http://rosettacode.org/wiki/Category:Programming_Languages'";
shell "wget -O categories.html 'http://www.rosettacode.org/mw/index.php?title=Special:Categories&limit=5000'";

my @lines = slurp('languages.html').lines;
shift @lines until @lines[0] ~~ / '<h2>Subcategories</h2>' /;
my @languages = gather for @lines {
    last if / '/bodycontent' /;
    take ~$0 if
        / '<li><a href="/wiki/Category:' .*? '" title="Category:' .*? '">' (.*?) '</a></li>' /;
}

my %valid = @languages X=> 1;

@lines = slurp('categories.html').lines;

my @results = sort -*.[0], gather for @lines {
    take [+$1, ~$0] if
        / '<li><a href="/wiki/Category:' .*? '" title="Category:' .*? '">'
        (.*?) <?{ %valid{ ~$0 } }>
        '</a>' .*? '(' (\d+) ' members)' /;
}

for @results.kv -> $i, @l {
    printf "%d:\t%3d - %s\n", $i+1, |@l;
}
