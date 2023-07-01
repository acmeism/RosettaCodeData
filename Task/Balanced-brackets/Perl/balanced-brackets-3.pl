use Regexp::Common 'balanced';
my $re = qr/^$RE{balanced}{-parens=>'[]'}$/;
sub balanced {
  return shift =~ $re;
}
