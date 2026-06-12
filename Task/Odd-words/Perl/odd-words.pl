#!/usr/bin/perl

@ARGV = 'unixdict.txt';
chomp( my @words = <> );
my %dict;
@dict{ grep length > 4, @words} = ();
for ( @words )
  {
  my $oddword = s/(.).?/$1/gr;
  exists $dict{$oddword} and print " $_ $oddword\n";
  }
