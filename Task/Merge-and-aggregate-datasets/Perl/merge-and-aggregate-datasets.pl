#!/usr/bin/perl
my $fmt = '| %-11s' x 5 . "|\n";
printf $fmt, qw( PATIENT_ID LASTNAME LAST_VISIT SCORE_SUM SCORE_AVG);
my ($names, $visits) = do { local $/; split /^\n/m, <DATA> };
my %score;
for ( $visits =~ /^\d.*/gm )
  {
  my ($id, undef, $score) = split /,/;
  $score{$id} //= ['', ''];
  $score and $score{$id}[0]++, $score{$id}[1] += $score;
  }
for ( sort $names =~ /^\d.*/gm )
  {
  my ($id, $name) = split /,/;
  printf $fmt, $id, $name, ( sort $visits =~ /^$id,(.*?),/gm, '' )[-1],
    $score{$id}[0]
      ? ( $score{$id}[1], $score{$id}[1] / $score{$id}[0])
      : ('', '');
  }

__DATA__
PATIENT_ID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz

PATIENT_ID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3
