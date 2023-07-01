ce:count each
lc:ce group@                                              / letter count
dict:"\n"vs .Q.hg "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
// dictionary of 3-9 letter words
d39:{x where(ce x)within 3 9}{x where all each x in .Q.a}dict

solve:{[grid;dict]
  i:where(grid 4)in'dict;
  dict i where all each 0<=(lc grid)-/:lc each dict i }[;d39]
