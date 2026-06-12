my %ei = 'unixdict.txt'.IO.words.grep({ .chars > 5 and /<[ie]>/ }).map: { $_ => .subst('e', 'i', :g) };
put %ei.grep( *.key.contains: 'e' ).grep({ %ei{.value}:exists }).sort.batch(4)».gist».fmt('%-22s').join: "\n";
