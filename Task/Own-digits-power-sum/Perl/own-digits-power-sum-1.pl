use strict;
use warnings;
use feature 'say';
use List::Util 'sum';
use Parallel::ForkManager;

my %own_dps;
my($lo,$hi) = (3,9);
my $cores   = 8;     # configure to match hardware being used

my $start = 10**($lo-1);
my $stop  = 10**$hi - 1;
my $step  = int(1 + ($stop - $start)/ ($cores+1));

my $pm = Parallel::ForkManager->new($cores);

RUN:
for my $i ( 0 .. $cores ) {

    $pm->run_on_finish (
        sub {
            my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_ref) = @_;
            $own_dps{$ident} = $data_ref;
        }
    );

    $pm->start($i) and next RUN;

    my @values;
    for my $n ( ($start + $i*$step) .. ($start + ($i+1)*$step) ) {
        push @values, $n if $n == sum map { $_**length($n) } split '', $n;
    }

    $pm->finish(0, \@values)
}

$pm->wait_all_children;

say $_ for sort { $a <=> $b } map { @$_ } values %own_dps;
