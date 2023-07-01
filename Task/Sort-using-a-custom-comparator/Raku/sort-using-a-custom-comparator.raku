my @strings = <Here are some sample strings to be sorted>;
put @strings.sort:{.chars, .lc};
put sort -> $x { $x.chars, $x.lc }, @strings;
