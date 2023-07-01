#!/usr/bin/perl

use strict;   # gen.pl - flatAST to stack machine code
use warnings; # http://www.rosettacode.org/wiki/Compiler/code_generator

my $stringcount = my $namecount = my $pairsym = my $pc = 0;
my (%strings, %names);
my %opnames = qw( Less lt LessEqual le Multiply mul Subtract sub Divide div
  GreaterEqual ge Equal eq Greater gt NotEqual ne Negate neg );

sub tree
  {
  my ($A, $B) = ( '_' . ++$pairsym, '_' . ++$pairsym ); # labels for jumps
  my $line = <> // return '';
  (local $_, my $arg) = $line =~ /^(\w+|;)\s+(.*)/ or die "bad input $line";
  /Identifier/ ? "fetch [@{[ $names{$arg} //= $namecount++ ]}]\n" :
    /Sequence/ ? tree() . tree() :
    /Integer/  ? "push  $arg\n" :
    /String/   ? "push  @{[ $strings{$arg} //= $stringcount++ ]}\n" :
    /Assign/   ? join '', reverse tree() =~ s/fetch/store/r, tree() :
    /While/    ? "$A:\n@{[ tree() ]}jz    $B\n@{[ tree() ]}jmp   $A\n$B:\n" :
    /If/       ? tree() . "jz    $A\n@{[ !<> . # !<> skips second 'If'
                  tree() ]}jmp   $B\n$A:\n@{[ tree() ]}$B:\n" :
    /;/        ? '' :
    tree() . tree() . ($opnames{$_} // lc) . "\n";
  }

$_ = tree() . "halt\n";

s/^jmp\s+(\S+)\n(_\d+:\n)\1:\n/$2/gm;                # remove jmp next
s/^(?=[a-z]\w*(.*))/                                 # add locations
  (sprintf("%4d ", $pc), $pc += $1 ? 5 : 1)[0] /gem;
my %labels = /^(_\d+):(?=(?:\n_\d+:)*\n *(\d+) )/gm; # pc addr of labels
s/^ *(\d+) j(?:z|mp) *\K(_\d+)$/ (@{[                # fix jumps
  $labels{$2} - $1 - 1]}) $labels{$2}/gm;
s/^_\d+.*\n//gm;                                     # remove labels

print "Datasize: $namecount Strings: $stringcount\n";
print "$_\n" for sort { $strings{$a} <=> $strings{$b} } keys %strings;
print;
