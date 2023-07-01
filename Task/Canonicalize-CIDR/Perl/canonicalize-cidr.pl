#!/usr/bin/env perl
use v5.16;
use Socket qw(inet_aton inet_ntoa);

# canonicalize a CIDR block: make sure none of the host bits are set
if (!@ARGV) {
   chomp(@ARGV = <>);
}

for (@ARGV) {

  # dotted-decimal / bits in network part
  my ($dotted, $size) = split m#/#;

  # get IP as binary string
  my $binary = sprintf "%032b", unpack('N', inet_aton $dotted);

  # Replace the host part with all zeroes
  substr($binary, $size) = 0 x (32 - $size);

  # Convert back to dotted-decimal
  $dotted = inet_ntoa(pack 'B32', $binary);

  # And output
  say "$dotted/$size";
}
