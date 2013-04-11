use strict;
use warnings;

use constant RESULT_TEMPLATE => "%-19s = %12.3f / %-6u = %.3f\n";

my $parser = Parser->new;

# parse lines and print results
printf RESULT_TEMPLATE, $parser->parse(split)
    while <>;

$parser->finish;

# print total and summary
printf "\n".RESULT_TEMPLATE."\n", $parser->result;
printf "the maximum of %u consecutive bad values was reached %u time(s)\n",
    $parser->bad_max, scalar $parser->bad_ranges;

# print bad ranges
print for map { '  '.join(' - ', @$_)."\n" } $parser->bad_ranges;

BEGIN {
    package main::Parser;

    sub new {
        my $obj = {
            SUM => 0,
            COUNT => 0,
            CURRENT_DATE => undef,
            BAD_DATE => undef,
            BAD_RANGES => [],
            BAD_MAX => 0,
            BAD_COUNT => 0
        };

        return bless $obj;
    }

    sub _average {
        my ($sum, $count) = @_;
        return ($sum, $count, $count && $sum / $count);
    }

    sub _push_bad_range_if_necessary {
        my ($parser) = @_;
        my ($count, $max) = @$parser{qw(BAD_COUNT BAD_MAX)};

        return if $count < $max;

        if ($count > $max) {
            $parser->{BAD_RANGES} = [];
            $parser->{BAD_MAX} = $count;
        }

        push @{$parser->{BAD_RANGES}}, [ @$parser{qw(BAD_DATE CURRENT_DATE)} ];
    }

    sub _check {
        my ($parser, $flag) = @_;
        if ($flag <= 0) {
            ++$parser->{BAD_COUNT};
            $parser->{BAD_DATE} = $parser->{CURRENT_DATE}
                unless defined $parser->{BAD_DATE};

            return 0;
        }
        else {
            $parser->_push_bad_range_if_necessary;
            $parser->{BAD_COUNT} = 0;
            $parser->{BAD_DATE} = undef;
            return 1;
        }
    }

    sub bad_max {
        my ($parser) = @_;
        return $parser->{BAD_MAX}
    }

    sub bad_ranges {
        my ($parser) = @_;
        return @{$parser->{BAD_RANGES}}
    }

    sub parse {
        my $parser = shift;
        my $date = shift;

        $parser->{CURRENT_DATE} = $date;

        my $sum = 0;
        my $count = 0;

        while (my ($value, $flag) = splice @_, 0, 2) {
            next unless $parser->_check($flag);
            $sum += $value;
            ++$count;
        }

        $parser->{SUM} += $sum;
        $parser->{COUNT} += $count;

        return ("average($date)", _average($sum, $count));
    }

    sub result {
        my ($parser) = @_;
        return ('total-average', _average(@$parser{qw(SUM COUNT)}));
    }

    sub finish {
        my ($parser) = @_;
        $parser->_push_bad_range_if_necessary
    }
}
