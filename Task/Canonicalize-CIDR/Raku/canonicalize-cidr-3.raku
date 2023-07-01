# canonicalize a IP4 CIDR block
sub CIDR-IP4-canonicalize ($address) {
  constant @mask = 24, 16, 8, 0;

  # dotted-decimal / subnet size
  my ($dotted, $size) = |$address.split('/'), 32;

  # get IP as binary address
  my $binary = sum $dotted.comb(/\d+/) Z+< @mask;

  # mask off subnet
  $binary +&= (2 ** $size - 1) +< (32 - $size);

  # Return dotted-decimal notation
  (@mask.map($binary +> * +& 0xFF).join('.'), $size)
}

my @tests = <
  87.70.141.1/22
  36.18.154.103/12
  62.62.197.11/29
  67.137.119.181/4
  161.214.74.21/24
  184.232.176.184/18
  100.68.0.18/18
  10.4.30.77/30
  10.207.219.251/32
  10.207.219.251
  110.200.21/4
  10.11.12.13/8
  10.../8
>;

printf "CIDR: %18s  Routing prefix: %s/%s\n", $_, |.&CIDR-IP4-canonicalize
  for @*ARGS || @tests;
