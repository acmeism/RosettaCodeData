my $lang = '(no language)';
my $total = 0;
my %blanks;

for lines() {
  when / '<lang>' / {
    %blanks{$lang}++;
    $total++;
  }
  when ms/ '==' '{{' 'header' '|' ( <-[}]>+? ) '}}' '==' / {
    $lang = $0.lc;
  }
}

say "$total bare language tag{ 's' if $total != 1 }\n";
say .value, ' in ', .key for %blanks.sort;
