sub dr (Int $_ is copy) { $_ = .comb.sum while .chars > 1; $_ }

my %hex = './unixdict.txt'.IO.slurp.words.grep( *.chars > 3 )\
  .grep({ not / <-[abcdef]> / }).map: { $_ => dr :16($_).comb.sum }

say "{+%hex} hex words longer than 3 characters found in unixdict.txt:";
printf "%6s ➡ %8d ➡ %d\n", .key, :16(.key), .value for %hex.sort: { .value, .key }

my %many = %hex.grep: +*.key.comb.Set > 3;

say "\nOf which {+%many} contain at least four distinct characters:";
printf "%6s ➡ %8d ➡ %d\n", .key, :16(.key), .value for %many.sort: { -:16(.key) }
