say "{.[0]+1}: ",$_ for grep *.all.is-prime, ^6000 .race.map: { $_-1, $_+3, $_+5 };
