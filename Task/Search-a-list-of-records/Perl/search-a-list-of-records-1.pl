use feature 'say';
use List::Util qw(first);

my @cities = (
  { name => 'Lagos',                population => 21.0  },
  { name => 'Cairo',                population => 15.2  },
  { name => 'Kinshasa-Brazzaville', population => 11.3  },
  { name => 'Greater Johannesburg', population =>  7.55 },
  { name => 'Mogadishu',            population =>  5.85 },
  { name => 'Khartoum-Omdurman',    population =>  4.98 },
  { name => 'Dar Es Salaam',        population =>  4.7  },
  { name => 'Alexandria',           population =>  4.58 },
  { name => 'Abidjan',              population =>  4.4  },
  { name => 'Casablanca',           population =>  3.98 },
);

my $index1 = first { $cities[$_]{name} eq 'Dar Es Salaam' } 0..$#cities;
say $index1;

my $record2 = first { $_->{population} < 5 } @cities;
say $record2->{name};

my $record3 = first { $_->{name} =~ /^A/ } @cities;
say $record3->{population};
