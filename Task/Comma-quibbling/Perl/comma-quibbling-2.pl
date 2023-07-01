use 5.01;
sub comma_quibbling {
  my $last = pop // '';
  return '{'. (@_ ? (join ', ', @_).' and '.$last : $last).'}';
}

say for map {comma_quibbling(@$_)}
  [], [qw(ABC)], [qw(ABC DEF)], [qw(ABC DEF G H)];
