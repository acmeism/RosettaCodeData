#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

# CFData container
package CFData {
    sub new {
        my ($class, $text, $arguments, $iterator) = @_;
        return bless {
            text      => $text,
            arguments => $arguments,
            iterator  => $iterator,
        }, $class;
    }
}

# NG class
package NG {
    sub new {
        my ($class, $args) = @_;
        my ($a1, $a, $b1, $b) = @$args;
        return bless {
            a1 => $a1,
            a  => $a,
            b1 => $b1,
            b  => $b,
        }, $class;
    }

    sub ingress {
        my ($self, $aN) = @_;
        my $temp = $self->{a};
        $self->{a} = $self->{a1};
        $self->{a1} = $temp + $self->{a1} * $aN;

        $temp = $self->{b};
        $self->{b} = $self->{b1};
        $self->{b1} = $temp + $self->{b1} * $aN;
    }

    sub egress {
        my ($self) = @_;
        my $n = int($self->{a} / $self->{b});
        my $temp = $self->{a};
        $self->{a} = $self->{b};
        $self->{b} = $temp - $self->{b} * $n;

        $temp = $self->{a1};
        $self->{a1} = $self->{b1};
        $self->{b1} = $temp - $self->{b1} * $n;

        return $n;
    }

    sub needsTerm {
        my ($self) = @_;
        return ($self->{b} == 0 || $self->{b1} == 0) || ($self->{a} * $self->{b1} != $self->{a1} * $self->{b});
    }

    sub egressDone {
        my ($self) = @_;
        if ($self->needsTerm()) {
            $self->{a} = $self->{a1};
            $self->{b} = $self->{b1};
        }
        return $self->egress();
    }

    sub done {
        my ($self) = @_;
        return ($self->{b} == 0 || $self->{b1} == 0);
    }
}

# CFIterator base class
package CFIterator {
    sub new {
        my ($class) = @_;
        return bless {}, $class;
    }
}

# R2cfIterator
package R2cfIterator {
    use parent -norequire, 'CFIterator';

    sub new {
        my ($class, $numerator, $denominator) = @_;
        return bless {
            numerator   => $numerator,
            denominator => $denominator,
        }, $class;
    }

    sub hasNext {
        my ($self) = @_;
        return $self->{denominator} != 0;
    }

    sub next {
        my ($self) = @_;
        my $div = int($self->{numerator} / $self->{denominator});
        my $rem = $self->{numerator} % $self->{denominator};
        $self->{numerator} = $self->{denominator};
        $self->{denominator} = $rem;
        return $div;
    }
}

# Root2
package Root2 {
    use parent -norequire, 'CFIterator';

    sub new {
        my ($class) = @_;
        return bless {
            firstReturn => 1,
        }, $class;
    }

    sub hasNext { return 1; }

    sub next {
        my ($self) = @_;
        if ($self->{firstReturn}) {
            $self->{firstReturn} = 0;
            return 1;
        }
        return 2;
    }
}

# ReciprocalRoot2
package ReciprocalRoot2 {
    use parent -norequire, 'CFIterator';

    sub new {
        my ($class) = @_;
        return bless {
            firstReturn  => 1,
            secondReturn => 1,
        }, $class;
    }

    sub hasNext { return 1; }

    sub next {
        my ($self) = @_;
        if ($self->{firstReturn}) {
            $self->{firstReturn} = 0;
            return 0;
        }
        if ($self->{secondReturn}) {
            $self->{secondReturn} = 0;
            return 1;
        }
        return 2;
    }
}

# Main execution
package main;

my @cfData = (
    CFData->new("[1; 5, 2] + 1 / 2    ", [2, 1, 0, 2], R2cfIterator->new(13, 11)),
    CFData->new("[3; 7] + 1 / 2       ", [2, 1, 0, 2], R2cfIterator->new(22, 7)),
    CFData->new("[3; 7] divided by 4  ", [1, 0, 0, 4], R2cfIterator->new(22, 7)),
    CFData->new("sqrt(2)              ", [0, 1, 1, 0], Root2->new()),
    CFData->new("1 / sqrt(2)          ", [0, 1, 1, 0], ReciprocalRoot2->new()),
    CFData->new("(1 + sqrt(2)) / 2    ", [1, 1, 0, 2], Root2->new()),
    CFData->new("(1 + 1 / sqrt(2)) / 2", [1, 1, 0, 2], ReciprocalRoot2->new()),
);

for my $data (@cfData) {
    print $data->{text} . " -> ";
    my $ng = NG->new($data->{arguments});
    my $iterator = $data->{iterator};
    my $nextTerm = 0;

    for my $i (1..20) {
        last unless $iterator->hasNext();
        $nextTerm = $iterator->next();
        if (!$ng->needsTerm()) {
            print $ng->egress() . " ";
        }
        $ng->ingress($nextTerm);
    }

    while (!$ng->done()) {
        print $ng->egressDone() . " ";
    }
    print "\n";
}
