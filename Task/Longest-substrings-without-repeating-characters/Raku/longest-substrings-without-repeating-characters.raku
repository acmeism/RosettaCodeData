sub abbreviate ($_) { .chars > 80 ?? "(abbreviated)\n" ~ .substr(0,35) ~ ' ... ' ~ .substr(*-35) !! $_ }

sub longest ($string) {
   return 0 => [] unless $string.chars;
   my ($start, $end, @substr) = 0, 0;
   while ++$end < $string.chars {
       my $sub = $string.substr($start, $end - $start);
       if $sub.contains: my $next = $string.substr: $end, 1 {
           @substr[$end - $start].push($sub) if $end - $start >= @substr.end;
           $start += 1 + $sub.index($next);
       }
   }
   @substr[$end - $start].push: $string.substr($start);
   @substr.pairs.tail
}

# Testing
say "\nOriginal string: {abbreviate $_}\nLongest substring(s) chars: ", .&longest

# Standard tests
for flat qww< xyzyabcybdfd xyzyab zzzzz a '' >,

# multibyte Unicode
< 👒🎩🎓👩‍👩‍👦‍👦🧢🎓👨‍👧‍👧👒👩‍👩‍👦‍👦🎩🎓👒🧢 α⊆϶α϶ >,

# check a file
slurp 'unixdict.txt';
