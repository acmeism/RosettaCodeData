#!/usr/bin/perl

# http://www.rosettacode.org/wiki/Compiler/virtual_machine_interpreter
use strict; # vm.pl - run rosetta code
use warnings;
use integer;

my ($binary, $pc, @stack, @data) = ('', 0);

<> =~ /Strings: (\d+)/ or die "bad header";
my @strings = map <> =~ tr/\n""//dr =~ s/\\(.)/$1 eq 'n' ? "\n" : $1/ger, 1..$1;

sub value { unpack 'l', substr $binary, ($pc += 4) - 4, 4 }

my @ops = (
  [ halt  => sub { exit } ],
  [ add   => sub { $stack[-2] += pop @stack } ],
  [ sub   => sub { $stack[-2] -= pop @stack } ],
  [ mul   => sub { $stack[-2] *= pop @stack } ],
  [ div   => sub { $stack[-2] /= pop @stack } ],
  [ mod   => sub { $stack[-2] %= pop @stack } ],
  [ not   => sub { $stack[-1] = $stack[-1] ? 0 : 1 } ],
  [ neg   => sub { $stack[-1] = - $stack[-1] } ],
  [ and   => sub { $stack[-2] &&= $stack[-1]; pop @stack } ],
  [ or    => sub { $stack[-2] ||= $stack[-1]; pop @stack } ],
  [ lt    => sub { $stack[-1] = $stack[-2] <  pop @stack ? 1 : 0 } ],
  [ gt    => sub { $stack[-1] = $stack[-2] >  pop @stack ? 1 : 0 } ],
  [ le    => sub { $stack[-1] = $stack[-2] <= pop @stack ? 1 : 0 } ],
  [ ge    => sub { $stack[-1] = $stack[-2] >= pop @stack ? 1 : 0 } ],
  [ ne    => sub { $stack[-1] = $stack[-2] != pop @stack ? 1 : 0 } ],
  [ eq    => sub { $stack[-1] = $stack[-2] == pop @stack ? 1 : 0 } ],
  [ prts  => sub { print $strings[pop @stack] } ],
  [ prti  => sub { print pop @stack } ],
  [ prtc  => sub { print chr pop @stack } ],
  [ store => sub { $data[value()] = pop @stack } ],
  [ fetch => sub { push @stack, $data[value()] // 0 } ],
  [ push  => sub { push @stack, value() } ],
  [ jmp   => sub { $pc += value() - 4 } ],
  [ jz    => sub { $pc += pop @stack ? 4 : value() - 4 } ],
  );
my %op2n = map { $ops[$_][0], $_ } 0..$#ops;            # map name to op number

while(<>)
  {
  /^ *\d+ +(\w+)/ or die "bad line $_";                 # format error
  $binary .= chr( $op2n{$1} // die "$1 not defined" ) . # op code
    (/\((-?\d+)\)|(\d+)]?$/ and pack 'l', $+);          # 4 byte value
  }

$ops[vec($binary, $pc++, 8)][1]->() while 1;            # run it
