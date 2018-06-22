my @strings = <Here are some sample strings to be sorted>;
my @sorted_strings = sort { $^a.chars <=> $^b.chars or $^a.lc cmp $^b.lc }, @strings;
.say for @sorted_strings;

# If instead the function you feed to <code>sort</code> is of arity 1, it will do the Schwartzian transform for you, automatically sorting numeric fields numerically, and strings fields stringily:

say @sorted_strings = sort -> $x { [ $x.chars, $x.lc ] }, @strings;
