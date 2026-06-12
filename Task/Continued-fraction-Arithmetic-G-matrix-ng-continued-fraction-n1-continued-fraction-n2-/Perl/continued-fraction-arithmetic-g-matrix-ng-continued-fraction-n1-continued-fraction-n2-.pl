#!/usr/bin/perl
use strict;
use warnings;
use utf8;

# Main test function
sub main {
    test("[3; 7] + [0; 2]",
        NG->new(NG8->new(0, 1, 1, 0, 0, 0, 0, 1), [R2cf->new(1, 2), R2cf->new(22, 7)]),
        NG->new(NG4->new(2, 1, 0, 2), [R2cf->new(22, 7)])
    );

    test("[1; 5, 2] * [3; 7]",
        NG->new(NG8->new(1, 0, 0, 0, 0, 0, 0, 1), [R2cf->new(13, 11), R2cf->new(22, 7)]),
        R2cf->new(286, 77)
    );

    test("[1; 5, 2] - [3; 7]",
        NG->new(NG8->new(0, 1, -1, 0, 0, 0, 0, 1), [R2cf->new(13, 11), R2cf->new(22, 7)]),
        R2cf->new(-151, 77)
    );

    test("Divide [] by [3; 7]",
        NG->new(NG8->new(0, 1, 0, 0, 0, 0, 1, 0), [R2cf->new(22 * 22, 7 * 7), R2cf->new(22, 7)])
    );

    test("([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])",
        NG->new(NG8->new(1, 0, 0, 0, 0, 0, 0, 1),
            [
                NG->new(NG8->new(0, 1, 1, 0, 0, 0, 0, 1), [R2cf->new(2, 7), R2cf->new(13, 11)]),
                NG->new(NG8->new(0, 1, -1, 0, 0, 0, 0, 1), [R2cf->new(2, 7), R2cf->new(13, 11)])
            ]
        ),
        R2cf->new(-7797, 5929)
    );
}

# Test function
sub test {
    my ($description, @fractions) = @_;
    print "Testing: $description\n";
    for my $fraction (@fractions) {
        while ($fraction->hasMoreTerms()) {
            print $fraction->nextTerm() . " ";
        }
        print "\n";
    }
    print "\n";
}

# MatrixNG base class
{
    package MatrixNG;

    sub new {
        my $class = shift;
        my $self = {
            configuration => 0,
            currentTerm => 0,
            hasTerm => 0,
        };
        bless $self, $class;
        return $self;
    }
}

# NG4 class
{
    package NG4;
    use parent -norequire, 'MatrixNG';

    sub new {
        my ($class, $a1, $a, $b1, $b) = @_;
        my $self = $class->SUPER::new();
        $self->{a1} = $a1;
        $self->{a} = $a;
        $self->{b1} = $b1;
        $self->{b} = $b;
        return bless $self, $class;
    }

    sub consumeTerm {
        my $self = shift;
        $self->{a} = $self->{a1};
        $self->{b} = $self->{b1};
    }

    sub consumeTermWithN {
        my ($self, $n) = @_;
        my $temp = $self->{a};
        $self->{a} = $self->{a1};
        $self->{a1} = $temp + $self->{a1} * $n;
        $temp = $self->{b};
        $self->{b} = $self->{b1};
        $self->{b1} = $temp + $self->{b1} * $n;
    }

    sub needsTerm {
        my $self = shift;

        if ($self->{b1} == 0 && $self->{b} == 0) {
            return 0;
        }
        if ($self->{b1} == 0 || $self->{b} == 0) {
            return 1;
        }

        $self->{currentTerm} = int($self->{a} / $self->{b});
        if ($self->{currentTerm} == int($self->{a1} / $self->{b1})) {
            my $temp = $self->{a};
            $self->{a} = $self->{b};
            $self->{b} = $temp - $self->{b} * $self->{currentTerm};
            $temp = $self->{a1};
            $self->{a1} = $self->{b1};
            $self->{b1} = $temp - $self->{b1} * $self->{currentTerm};

            $self->{hasTerm} = 1;
            return 0;
        }
        return 1;
    }
}

# NG8 class
{
    package NG8;
    use parent -norequire, 'MatrixNG';

    sub new {
        my ($class, $a12, $a1, $a2, $a, $b12, $b1, $b2, $b) = @_;
        my $self = $class->SUPER::new();
        $self->{a12} = $a12;
        $self->{a1} = $a1;
        $self->{a2} = $a2;
        $self->{a} = $a;
        $self->{b12} = $b12;
        $self->{b1} = $b1;
        $self->{b2} = $b2;
        $self->{b} = $b;
        $self->{ab} = 0;
        $self->{a1b1} = 0;
        $self->{a2b2} = 0;
        $self->{a12b12} = 0;
        return bless $self, $class;
    }

    sub consumeTerm {
        my $self = shift;
        if ($self->{configuration} == 0) {
            $self->{a} = $self->{a1};
            $self->{a2} = $self->{a12};
            $self->{b} = $self->{b1};
            $self->{b2} = $self->{b12};
        } else {
            $self->{a} = $self->{a2};
            $self->{a1} = $self->{a12};
            $self->{b} = $self->{b2};
            $self->{b1} = $self->{b12};
        }
    }

    sub consumeTermWithN {
        my ($self, $n) = @_;
        if ($self->{configuration} == 0) {
            my $temp = $self->{a};
            $self->{a} = $self->{a1};
            $self->{a1} = $temp + $self->{a1} * $n;
            $temp = $self->{a2};
            $self->{a2} = $self->{a12};
            $self->{a12} = $temp + $self->{a12} * $n;
            $temp = $self->{b};
            $self->{b} = $self->{b1};
            $self->{b1} = $temp + $self->{b1} * $n;
            $temp = $self->{b2};
            $self->{b2} = $self->{b12};
            $self->{b12} = $temp + $self->{b12} * $n;
        } else {
            my $temp = $self->{a};
            $self->{a} = $self->{a2};
            $self->{a2} = $temp + $self->{a2} * $n;
            $temp = $self->{a1};
            $self->{a1} = $self->{a12};
            $self->{a12} = $temp + $self->{a12} * $n;
            $temp = $self->{b};
            $self->{b} = $self->{b2};
            $self->{b2} = $temp + $self->{b2} * $n;
            $temp = $self->{b1};
            $self->{b1} = $self->{b12};
            $self->{b12} = $temp + $self->{b12} * $n;
        }
    }

    sub needsTerm {
        my $self = shift;

        if ($self->{b1} == 0 && $self->{b} == 0 && $self->{b2} == 0 && $self->{b12} == 0) {
            return 0;
        }

        if ($self->{b} == 0) {
            $self->{configuration} = ($self->{b2} == 0) ? 0 : 1;
            return 1;
        }
        $self->{ab} = $self->{a} / $self->{b};

        if ($self->{b2} == 0) {
            $self->{configuration} = 1;
            return 1;
        }
        $self->{a2b2} = $self->{a2} / $self->{b2};

        if ($self->{b1} == 0) {
            $self->{configuration} = 0;
            return 1;
        }
        $self->{a1b1} = $self->{a1} / $self->{b1};

        if ($self->{b12} == 0) {
            $self->{configuration} = $self->_setConfiguration();
            return 1;
        }
        $self->{a12b12} = $self->{a12} / $self->{b12};

        $self->{currentTerm} = int($self->{ab});
        if ($self->{currentTerm} == int($self->{a1b1}) &&
            $self->{currentTerm} == int($self->{a2b2}) &&
            $self->{currentTerm} == int($self->{a12b12})) {

            my $temp = $self->{a};
            $self->{a} = $self->{b};
            $self->{b} = $temp - $self->{b} * $self->{currentTerm};
            $temp = $self->{a1};
            $self->{a1} = $self->{b1};
            $self->{b1} = $temp - $self->{b1} * $self->{currentTerm};
            $temp = $self->{a2};
            $self->{a2} = $self->{b2};
            $self->{b2} = $temp - $self->{b2} * $self->{currentTerm};
            $temp = $self->{a12};
            $self->{a12} = $self->{b12};
            $self->{b12} = $temp - $self->{b12} * $self->{currentTerm};

            $self->{hasTerm} = 1;
            return 0;
        }
        $self->{configuration} = $self->_setConfiguration();
        return 1;
    }

    sub _setConfiguration {
        my $self = shift;
        return (abs($self->{a1b1} - $self->{ab}) > abs($self->{a2b2} - $self->{ab})) ? 0 : 1;
    }
}

# ContinuedFraction interface
{
    package ContinuedFraction;
}

# R2cf class
{
    package R2cf;
    use parent -norequire, 'ContinuedFraction';

    sub new {
        my ($class, $n1, $n2) = @_;
        my $self = {
            n1 => $n1,
            n2 => $n2
        };
        return bless $self, $class;
    }

    sub hasMoreTerms {
        my $self = shift;
        return abs($self->{n2}) > 0;
    }

    sub nextTerm {
        my $self = shift;
        my $term = int($self->{n1} / $self->{n2});
        my $temp = $self->{n2};
        $self->{n2} = $self->{n1} - $term * $self->{n2};
        $self->{n1} = $temp;
        return $term;
    }
}

# NG class
{
    package NG;
    use parent -norequire, 'ContinuedFraction';

    sub new {
        my ($class, $matrixNG, $cf) = @_;
        my $self = {
            matrixNG => $matrixNG,
            cf => $cf
        };
        return bless $self, $class;
    }

    sub hasMoreTerms {
        my $self = shift;
        while ($self->{matrixNG}->needsTerm()) {
            if ($self->{cf}[$self->{matrixNG}->{configuration}]->hasMoreTerms()) {
                $self->{matrixNG}->consumeTermWithN(
                    $self->{cf}[$self->{matrixNG}->{configuration}]->nextTerm()
                );
            } else {
                $self->{matrixNG}->consumeTerm();
            }
        }
        return $self->{matrixNG}->{hasTerm};
    }

    sub nextTerm {
        my $self = shift;
        $self->{matrixNG}->{hasTerm} = 0;
        return $self->{matrixNG}->{currentTerm};
    }
}

# Run the main function
main() unless caller;
