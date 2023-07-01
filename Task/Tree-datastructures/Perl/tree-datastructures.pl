use strict;
use warnings;
use feature 'say';
use JSON;
use Data::Printer;

my $trees = <<~END;
    RosettaCode
      encourages
        code
          diversity
          comparison
      discourages
        golfing
        trolling
        emphasising execution speed
    code-golf.io
      encourages
        golfing
      discourages
        comparison
    END

my $level = '  ';
sub nested_to_indent { shift =~ s#^($level*)# ($1 ? length($1)/length $level : 0) . ' ' #egmr }
sub indent_to_nested { shift =~ s#^(\d+)\s*# $level x $1 #egmr }

say my $indent = nested_to_indent $trees;
    my $nest   = indent_to_nested $indent;

use Test::More;
is($trees, $nest, 'Round-trip');
done_testing();

# Import outline paragraph into native data structure
sub import {
    my($trees) = @_;
    my $level = '  ';
    my $forest;
    my $last = -999;

    for my $branch (split /\n/, $trees) {
        $branch =~ m/(($level*))*/;
        my $this = $1 ? length($1)/length($level) : 0;
        $forest .= do {
            if    ($this gt $last) { '['                   . trim_and_quote($branch) }
            elsif ($this lt $last) { ']'x($last-$this).',' . trim_and_quote($branch) }
            else                   {                         trim_and_quote($branch) }
        };
        $last = $this;
    }
    sub trim_and_quote { shift =~ s/^\s*(.*\S)\s*$/"$1",/r }

    eval $forest . ']' x (1+$last);
}

my $forest = import $trees;
say "Native data structure:\n" . np $forest;
say "\nJSON:\n" . encode_json($forest);
