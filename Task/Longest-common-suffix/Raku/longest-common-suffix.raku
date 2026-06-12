sub longest-common-suffix ( *@words ) {
    return '' unless +@words;
    my $min = @words».chars.min;
    for 1 .. * {
        return @words[0].substr(* - $min) if $_ > $min;
        next if @words».substr(* - $_).Set == 1;
        return @words[0].substr(* - $_ + 1);
    }
}

say "{$_.raku} - LCS: >{longest-common-suffix $_}<" for
  <Sunday Monday Tuesday Wednesday Thursday Friday Saturday>,
  <Sondag Maandag Dinsdag Woensdag Donderdag Vrydag Saterdag dag>,
  ( 2347, 9312347, 'acx5g2347', 12.02347 ),
  <longest common suffix>,
  ('one, Hey!', 'three, Hey!', 'ale, Hey!', 'me, Hey!'),
  'suffix',
  ''
