say (3..333).grep(*.is-prime).combinations(2).map( { next if (my $p = [*] $_) > 999; $p } ).flat\
    .sort.batch(20)».fmt('%3d').join: "\n";
