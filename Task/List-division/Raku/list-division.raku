for #       list                 parts
  <94 94 13 77 35 10 51 27 60>,    6,
  <19 46 43 17 94>,                1,
  <93 88 40 88 30 68 84 25>,       3,
  <88 94 10 27 54 14>,             3,
  <31 19 63 57 57 74 50 14 38>,    4,
  <72 57 89 55 36 84 10 95 99 35>, 7,
  <23 49 57>,                     10,
  [1],                             2,
  [],                              2
   -> @list, $parts {
      say "<{@list}> divided into $parts parts:\n{@list.&divide($parts).gist}\n";
}

say "<{'a'..'z'}> divided into $_ parts:\n{('a'..'z').&divide($_).gist}\n" for 2, 3, 5, 11, 13, 30;

sub divide (@list, Int $parts where * > 0) {
    note "Warning: parts ($parts) is greater than list elements ({+@list})." if $parts > +@list;
    my ($remainder, $size) = (+@list).polymod($parts);
    my ($begin, $end) = 0, $size;
    ++$end and $remainder-- if $remainder;
    gather for ^$parts {
        take @list[$begin..^$end];
        $begin = $end;
        $end += $size;
        ++$end and $remainder-- if $remainder;
    }
}
