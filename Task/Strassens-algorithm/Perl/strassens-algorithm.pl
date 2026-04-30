#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);

# Matrix class implemented as array reference
package Matrix;

# Constructor
sub new {
    my ($class, $data) = @_;
    my $self = defined $data ? $data : [];
    bless $self, $class;
    return $self;
}

# Create matrix from nested blocks
sub block {
    my ($class, $blocks) = @_;
    my @result;

    # Get dimensions
    my $num_rows = 0;
    for my $hblock (@$blocks) {
        $num_rows += @{$hblock->[0]};
    }

    # Process each horizontal block
    my $row_offset = 0;
    for my $hblock (@$blocks) {
        my $block_height = @{$hblock->[0]};
        # Zip and concatenate rows
        for my $i (0..$block_height-1) {
            my @new_row;
            for my $matrix (@$hblock) {
                push @new_row, @{$matrix->[$i]};
            }
            $result[$row_offset + $i] = \@new_row;
        }
        $row_offset += $block_height;
    }

    return Matrix->new(\@result);
}

# Matrix multiplication (naive)
sub dot {
    my ($self, $b) = @_;
    my ($rows_a, $cols_a) = $self->shape();
    my ($rows_b, $cols_b) = $b->shape();

    die "Matrix dimensions don't match for multiplication" unless $cols_a == $rows_b;

    my @result;
    for my $i (0..$rows_a-1) {
        my @row;
        for my $j (0..$cols_b-1) {
            my $sum = 0;
            for my $k (0..$cols_a-1) {
                $sum += $self->[$i][$k] * $b->[$k][$j];
            }
            push @row, $sum;
        }
        push @result, \@row;
    }

    return Matrix->new(\@result);
}

# Overload multiplication operator
use overload '*' => \&dot;

# Matrix addition
sub add {
    my ($self, $b) = @_;
    my ($rows, $cols) = $self->shape();
    my ($b_rows, $b_cols) = $b->shape();

    die "Matrix dimensions don't match for addition" unless $rows == $b_rows && $cols == $b_cols;

    my @result;
    for my $i (0..$rows-1) {
        my @row;
        for my $j (0..$cols-1) {
            push @row, $self->[$i][$j] + $b->[$i][$j];
        }
        push @result, \@row;
    }

    return Matrix->new(\@result);
}

# Matrix subtraction
sub subtract {
    my ($self, $b) = @_;
    my ($rows, $cols) = $self->shape();
    my ($b_rows, $b_cols) = $b->shape();

    die "Matrix dimensions don't match for subtraction" unless $rows == $b_rows && $cols == $b_cols;

    my @result;
    for my $i (0..$rows-1) {
        my @row;
        for my $j (0..$cols-1) {
            push @row, $self->[$i][$j] - $b->[$i][$j];
        }
        push @result, \@row;
    }

    return Matrix->new(\@result);
}

# Overload operators
use overload '+' => \&add;
use overload '-' => \&subtract;

# Strassen's algorithm
sub strassen {
    my ($self, $b) = @_;
    my ($rows, $cols) = $self->shape();
    my ($b_rows, $b_cols) = $b->shape();

    die "Matrices must be square" unless $rows == $cols && $b_rows == $b_cols;
    die "Matrices must be the same shape" unless $rows == $b_rows;
    die "Shape must be a power of 2" unless $rows > 0 && ($rows & ($rows - 1)) == 0;

    if ($rows == 1) {
        return $self->dot($b);
    }

    my $p = $rows / 2;

    # Partition matrices
    my $a11 = Matrix->new([map { [ @{$self->[$_]}[0..$p-1] ] } 0..$p-1]);
    my $a12 = Matrix->new([map { [ @{$self->[$_]}[$p..$rows-1] ] } 0..$p-1]);
    my $a21 = Matrix->new([map { [ @{$self->[$_]}[0..$p-1] ] } $p..$rows-1]);
    my $a22 = Matrix->new([map { [ @{$self->[$_]}[$p..$rows-1] ] } $p..$rows-1]);

    my $b11 = Matrix->new([map { [ @{$b->[$_]}[0..$p-1] ] } 0..$p-1]);
    my $b12 = Matrix->new([map { [ @{$b->[$_]}[$p..$b_cols-1] ] } 0..$p-1]);
    my $b21 = Matrix->new([map { [ @{$b->[$_]}[0..$p-1] ] } $p..$b_rows-1]);
    my $b22 = Matrix->new([map { [ @{$b->[$_]}[$p..$b_cols-1] ] } $p..$b_rows-1]);

    # Calculate M1..M7
    my $m1 = ($a11 + $a22)->strassen($b11 + $b22);
    my $m2 = ($a21 + $a22)->strassen($b11);
    my $m3 = $a11->strassen($b12 - $b22);
    my $m4 = $a22->strassen($b21 - $b11);
    my $m5 = ($a11 + $a12)->strassen($b22);
    my $m6 = ($a21 - $a11)->strassen($b11 + $b12);
    my $m7 = ($a12 - $a22)->strassen($b21 + $b22);

    # Calculate C11..C22
    my $c11 = $m1 + $m4 - $m5 + $m7;
    my $c12 = $m3 + $m5;
    my $c21 = $m2 + $m4;
    my $c22 = $m1 - $m2 + $m3 + $m6;

    return Matrix->block([[$c11, $c12], [$c21, $c22]]);
}

# Round elements
sub round_matrix {
    my ($self, $ndigits) = @_;
    $ndigits = undef unless defined $ndigits;

    my @result;
    for my $i (0..$#{$self}) {
        my @row;
        for my $j (0..$#{$self->[$i]}) {
            my $val = $self->[$i][$j];
            if (defined $ndigits) {
                push @row, sprintf("%.${ndigits}f", $val);
            } else {
                push @row, int($val + ($val >= 0 ? 0.5 : -0.5));
            }
        }
        push @result, \@row;
    }

    return Matrix->new(\@result);
}

# Get matrix shape
sub shape {
    my ($self) = @_;
    return (0, 0) unless @$self;
    return (scalar @$self, scalar @{$self->[0]});
}

# String representation
sub stringify {
    my ($self) = @_;
    my @rows;
    for my $row (@$self) {
        push @rows, '[' . join(', ', @$row) . ']';
    }
    return '[' . join(', ', @rows) . ']';
}

use overload '""' => \&stringify;

# Examples
package main;

sub examples {
    my $a = Matrix->new([
        [1, 2],
        [3, 4]
    ]);

    my $b = Matrix->new([
        [5, 6],
        [7, 8]
    ]);

    my $c = Matrix->new([
        [1, 1, 1, 1],
        [2, 4, 8, 16],
        [3, 9, 27, 81],
        [4, 16, 64, 256]
    ]);

    my $d = Matrix->new([
        [4, -3, 4/3, -1/4],
        [-13/3, 19/4, -7/3, 11/24],
        [3/2, -2, 7/6, -1/4],
        [-1/6, 1/4, -1/6, 1/24]
    ]);

    my $e = Matrix->new([
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16]
    ]);

    my $f = Matrix->new([
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1]
    ]);

    print "Naive matrix multiplication:\n";
    print "  a * b = " . ($a * $b) . "\n";
    print "  c * d = " . $c->round_matrix(0) . "\n";
    print "  e * f = " . ($e * $f) . "\n";

    print "Strassen's matrix multiplication:\n";
    print "  a * b = " . $a->strassen($b) . "\n";
    print "  c * d = " . $c->strassen($d)->round_matrix(0) . "\n";
    print "  e * f = " . $e->strassen($f) . "\n";
}

examples() if __FILE__ eq $0;
