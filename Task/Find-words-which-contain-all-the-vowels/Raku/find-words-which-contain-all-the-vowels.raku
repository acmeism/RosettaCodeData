put +.words, " words found:\n", $_ with 'unixdict.txt'.IO.words\
  .grep({ .chars > 10 and all(.comb.Bag<a e i o u>) == 1 })\
  .batch(5)».fmt('%-13s').join: "\n";
