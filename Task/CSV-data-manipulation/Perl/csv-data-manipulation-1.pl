#!/usr/bin/perl
use warnings;
use strict;

use List::Util 'sum';

my @header = split /,/, <>;
# Remove the newline.
chomp $header[-1];

my %column_number;
for my $i (0 .. $#header) {
    $column_number{$header[$i]} = $i;
}
my @rows   = map [ split /,/ ], <>;
chomp $_->[-1] for @rows;

# Add 1 to the numbers in the 2nd column:
$_->[1]++ for @rows;

# Add C1 into C4:
$_->[ $column_number{C4} ] += $_->[ $column_number{C1} ] for @rows;

# Add sums to both rows and columns.
push @header, 'Sum';
$column_number{Sum} = $#header;

push @$_, sum(@$_) for @rows;
push @rows, [
                map  {
                    my $col = $_;
                    sum(map $_->[ $column_number{$col} ], @rows);
                } @header
            ];

# Print the output.
print join(',' => @header), "\n";
print join(',' => @$_), "\n" for @rows;
