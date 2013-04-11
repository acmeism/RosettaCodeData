my @strings = <Here are some sample strings to be sorted>;
my @sorted_strings = sort { $^a.chars <=> $^b.chars or $^a.lc cmp $^b.lc }, @strings;
.say for @sorted_strings;
