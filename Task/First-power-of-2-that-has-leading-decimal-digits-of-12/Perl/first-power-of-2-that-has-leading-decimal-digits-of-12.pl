use strict;
use warnings;
use feature 'say';
use feature 'state';

use POSIX qw(fmod);
use Perl6::GatherTake;

use constant ln2ln10 => log(2) / log(10);

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub ordinal_digit {
    my($d) = $_[0] =~ /(.)$/;
    $d eq '1' ? 'st' : $d eq '2' ? 'nd' : $d eq '3' ? 'rd' : 'th'
}

sub startswith12 {
    my($nth) = @_;
    state $i = 0;
    state $n = 0;
    while (1) {
      next unless '1.2' eq substr(( 10 ** fmod(++$i * ln2ln10, 1) ), 0, 3);
      return $i if ++$n eq $nth;
    }
}

sub startswith123 {
    my $pre = '1.23';
    my ($this, $count) = (0, 0);

    gather {
      while (1) {
        if ($this == 196) {
            $this = 289;
            $this = 485 unless $pre eq substr(( 10 ** fmod(($count+$this) * ln2ln10, 1) ), 0, 4);
        } elsif ($this == 485) {
            $this = 196;
            $this = 485 unless $pre eq substr(( 10 ** fmod(($count+$this) * ln2ln10, 1) ), 0, 4);
        } elsif ($this == 289) {
            $this = 196
        } elsif ($this ==  90) {
            $this = 289
        } elsif ($this ==   0) {
            $this = 90;
        }
        take $count += $this;
      }
    }
}

my $start_123 = startswith123(); # lazy list

sub p {
    my($prefix,$nth) = @_;
    $prefix eq '12' ? startswith12($nth) : $start_123->[$nth-1];
}

for ([12, 1], [12, 2], [123, 45], [123, 12345], [123, 678910]) {
    my($prefix,$nth) = @$_;
    printf "%-15s %9s power of two (2^n) that starts with %5s is at n = %s\n", "p($prefix, $nth):",
        comma($nth) . ordinal_digit($nth), "'$prefix'", comma p($prefix, $nth);
}
