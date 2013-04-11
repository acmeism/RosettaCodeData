my $story = slurp(@*ARGS.shift);
my %words;
$story.=subst(/ '<' (.*?) '>' /, { %words{$0} //= prompt "$0? " }, :g );
say $story;
