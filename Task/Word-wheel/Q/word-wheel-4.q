best:{[dict]
  dlc:lc each dict;                                      / letter counts of dictionary words
  ig:where(ce dict)=9;                                   / find grids (9-letter words)
  igw:where each(all'')0<=(dlc ig)-/:\:dlc;              / find words composable from each grid (length ig)
  grids:raze(til 9)rotate\:/:dict ig;                    / 9 permutations of each grid
  iaz:(.Q.a)!where each .Q.a in'\:dict;                  / find words containing a, b, c etc
  ml:4 rotate'dict ig;                                   / mid letters for each grid
  wc:ce raze igw inter/:'iaz ml;                         / word counts for grids
  distinct grids where wc=max wc }                       / grids with most words
