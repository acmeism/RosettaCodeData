#!/usr/bin/env raku
unit sub MAIN(*@cidrs);

if !@cidrs {
  # test data
  @cidrs = «87.70.141.1/22 36.18.154.103/12 62.62.197.11/29 67.137.119.181/4 161.214.74.21/24 184.232.176.184/18»;
}

for @cidrs -> $cidr {
  say "$cidr -> $(canonicalize $cidr)";
}

# canonicalize a CIDR block: make sure none of the host bits are set
sub canonicalize($cidr) {
  # dotted-decimal / bits in network part
  my ($dotted, $size) = $cidr.split: '/';

  # get network part of the IP as binary string
  my $binary = $dotted.split('.')».fmt('%08b').join.substr(0, $size);

  # Add host part with all zeroes
  $binary ~= 0 x (32 - $size);

  # Convert back to dotted-decimal
  my $canon = $binary.comb(8)».parse-base(2).join: '.';

  # And output
  say "$canon/$size";
}
