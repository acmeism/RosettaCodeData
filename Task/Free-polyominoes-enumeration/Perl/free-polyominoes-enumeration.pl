#!/usr/bin/perl

use strict;
use warnings;

my @new = "#\n";

for my $N ( 2 .. 10 )
  {
  @new = find( @new );
  my %allbest;
  $allbest{best($_)}++ for @new;
  my @show = @new = sort keys %allbest;
  printf "rank: %2d  count: %d\n\n", $N, scalar @show;
  if( @show <= 12 )
    {
    my $fmt = join '', map({ /\n/; '%' . ($+[0] + 1) . 's' } @show), "\n";
    grep $_, @show and printf $fmt, map s/(.*)\n// && $1, @show for 0 .. $N;
    print "\n";
    }
  }

sub bare
  {
  local $_ = shift;
  s/^ *\n//gm;
  s/^ //gm until /^#/m;
  s/ $//gm until /#$/m;
  $_;
  }

sub transpose
  {
  local $_ = shift;
  my $t = '';
  $t .= "\n" while s/^./ $t .= $&; '' /gem;
  $t;
  }

sub rotate
  {
  local $_ = shift;
  my $t = '';
  $t .= "\n" while s/.$/ $t .= $&; '' /gem;
  $t;
  }

sub best
  {
  my %all = (shift, 1);
  for my $p (keys %all)
    {
    $all{ my $tmp = rotate $p }++;
    $all{ rotate $tmp }++;
    }
  $all{ transpose $_ }++ for keys %all;
  $all{ s/(.+)/reverse $1/ger }++ for keys %all;        # mirror
  (sort keys %all)[-1];
  }

sub find
  {
  my @before = @_;
  my %new;
  for my $p ( @before )
    {
    local $_ = $p;
    s/^/ /gm;
    s/\n/ \n/g;
    my $line = s/\n.*/\n/sr =~ tr/\n/ /cr;
    $_ = $line . $_ . $line;
    my $n = -1 + length $line;
    my $gap = qr/.{$n}/s;
    $new{ bare "$`#$'" }++ while / (?=#)/g;
    $new{ bare "$`#$'" }++ while / (?=$gap#)/g;
    $new{ bare "$`#$'" }++ while /(?<=#) /g;
    $new{ bare "$`#$'" }++ while /(?<=#$gap) /g;
    }
  keys %new;
  }
