#!/usr/bin/perl
use warnings;
use strict;

use Text::CSV;
use List::Util 'sum';

my $csv = 'Text::CSV'->new({eol => "\n"})
          or die 'Cannot use CSV: ' . 'Text::CSV'->error_diag;

my $file = shift;
my @rows;
open my $FH, '<', $file or die "Cannot open $file: $!";
my @header = @{ $csv->getline($FH) };
while (my $row = $csv->getline($FH)) {
    push @rows, $row;
}
$csv->eof or $csv->error_diag;

#
# The processing is the same.
#

# Print the output.
$csv->print(*STDOUT, $_) for \@header, @rows;
