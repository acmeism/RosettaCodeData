#!/usr/bin/perl

print $_ = <<'' =~ tr/./ /r; # test case, dots only for layout
.....
.....
.###.
.....
.....

my $gap = /..\n/ ? qr/.{$-[0]}/s : die "too small";
my $neighborhood = qr/(?<=(...) $gap (.)) . (?=(.) $gap (...))/x;

for my $generation ( 2 .. 4 )
  {
  s/$neighborhood/ substr "  $&#     ", "$1$2$3$4" =~ tr|#||, 1 /ge;
  print;
  }
