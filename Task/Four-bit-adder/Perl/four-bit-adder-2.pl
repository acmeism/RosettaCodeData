#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Four_bit_adder
use warnings;
use List::Util qw( any reduce uniq );

my $circuit = @ARGV ? join '', <> : <<END;
define xor a b => a^b       # internal test/demo circuit
not         a => !a         # from https://rosettacode.org/wiki/Four_bit_adder
not         b => !b
and      !a b => !a&b
and      a !b => a&!b
or  !a&b a&!b => a^b

define half_adder a b => carry sum
xor a b => sum
and a b => carry

define full_adder a b Cin => Cout sum
half_adder a Cin => c1 s1
half_adder s1 b  => c2 sum
        or c1 c2 => Cout

define Four_bit_adder a3 a2 a1 a0  b3 b2 b1 b0 => ovfl s3 s2 s1 s0
full_adder a0 b0  0 => c0   s0
full_adder a1 b1 c0 => c1   s1
full_adder a2 b2 c1 => c2   s2
full_adder a3 b3 c2 => ovfl s3

Four_bit_adder  0 ? ? ?  1 0 1 1 => carry s3 s2 s1 s0
END
our %values;
my (%blocks, @ranges);

sub parseline
  {
  $_[0] =~ /=>/ or die "parseline failed for '@_'\n";
  my ($name, @in) = split ' ', $`;
  return $name, \@in, [ uniq split ' ', $' ];
  }

sub simulate
  {
  my ($name, $in, $out) = parseline @_;
  my @inputs = map { /^[01]$/ ? $_ :
    $values{$_} // die "undefined name '$_' in '@_'\n" } @$in;
  my @outputs;
  if( $name eq 'and' ) { @outputs = (any { !$_ } @inputs) ? 0 : 1 }
  elsif( $name eq 'or' ) { @outputs = (any { $_ } @inputs) ? 1 : 0 }
  elsif( $name eq 'not' ) { @outputs = reduce { $a ^ $b } 1, @inputs }
  elsif( my $block = $blocks{$name} )
    {
    local %values;
    @values{ $block->{in}->@* } = @inputs;
    simulate( $_ ) for $block->{body}->@*;
    @outputs = map { $values{$_} // die "undefined name '$_' in '$name'\n" }
      $block->{out}->@*;
    }
  else { die "unknown block name '$name'\n" }
  @values{ @$out } = @outputs;
  }

sub many { map { /(?<=\h)\?(?=\h.*=>)/ ? many("$`0$'", "$`1$'") : $_ } @_ }

print '-' x 40, " CIRCUIT:\n\n$circuit\n";
s/#.*//g for $circuit; # remove comments
$circuit =~ s/^define\h(.*)\n((?:(?!define\h).*=>.*\n)+)/ # find the defines
  my @body = split m<\n>, $2;
  my ($name, $in, $out) = parseline $1;
  $blocks{$name} = { in => $in, out => $out, body => \@body };
  '' /gme;
$circuit =~ s/^.*\h\?\h.*=>.*/ push @ranges, $&; '' /gme;
$circuit =~ s/^(?!.*=>).*\n//gm; # clear out lines without =>
simulate $_ for split /\n/, $circuit;
my @values = map { sprintf '%*s', length, $values{$_} // '' } my @names =
  map { split } $circuit =~ /=>(.*)/gm;
@names and print '-' x 40, " OUTPUT:\n\n@names\n@values\n\n";

for ( many @ranges )
  {
  simulate $_;
  my @values = map { sprintf '%*s', length, $values{$_} // '' } my @names =
    map { split } /=>(.*)/;
  my $over = (my $base = s/=>\K.*//r) =~ tr/\t/ /cr;
  my $name = (split)[0];
  print '-' x 79, "\n$base @names\n$over @values\n";
  }
#use Data::Dump 'dd'; dd { blocks => \%blocks };
