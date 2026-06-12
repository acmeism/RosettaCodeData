use Text::Sorensen :sdi;

my %tasks = './tasks.txt'.IO.slurp.lines.race.map: { $_ => .&bi-gram };

sub fuzzy-search (Str $string) { sdi($string, %tasks, :ge(.2) ).head(5).join: "\n" }

say "\n$_ >\n" ~ .&fuzzy-search for
  'Primordial primes',
  'Sunkist-Giuliani formula',
  'Sieve of Euripides',
  'Chowder numbers';
