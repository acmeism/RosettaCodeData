#!/usr/bin/perl

my %code = split ' ', <<'END';
  >  $ptr++
  <  $ptr--
  +  $memory[$ptr]++
  -  $memory[$ptr]--
  ,  $memory[$ptr]=ord(getc)
  .  print(chr($memory[$ptr]))
  [  while($memory[$ptr]){
  ]  }
END

my ($ptr, @memory) = 0;
eval join ';', map @code{ /./g }, <>;
