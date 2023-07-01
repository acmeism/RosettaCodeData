my $lang = 'no language';
my $total = 0;
my %blanks = ();
while (<>) {
  if (m/<lang>/) {
    if (exists $blanks{lc $lang}) {
      $blanks{lc $lang}++
    } else {
      $blanks{lc $lang} = 1
    }
    $total++
  } elsif (m/==\s*\{\{\s*header\s*\|\s*([^\s\}]+)\s*\}\}\s*==/) {
    $lang = lc $1
  }
}

if ($total) {
	print "$total bare language tag" . ($total > 1 ? 's' : '') . ".\n\n";
	while ( my ($k, $v) = each(%blanks) ) {
		print "$k in $v\n"
	}
}
