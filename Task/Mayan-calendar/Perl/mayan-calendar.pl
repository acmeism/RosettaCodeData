use strict;
use warnings;
use utf8;
binmode STDOUT, ":utf8";
use Math::BaseArith;
use Date::Calc 'Delta_Days';

my @sacred = qw<Imix’ Ik’ Ak’bal K’an Chikchan Kimi Manik’ Lamat Muluk Ok
              Chuwen Eb Ben Hix Men K’ib’ Kaban Etz’nab’ Kawak Ajaw>;

my @civil = qw<Pop Wo’ Sip Sotz’ Sek Xul Yaxk’in Mol Ch’en Yax Sak’ Keh
             Mak K’ank’in Muwan’ Pax K’ayab Kumk’u Wayeb’>;

my %correlation = (
    'gregorian' => '2012-12-21',
    'round'     => [3,19,263,8],
    'long'      => 1872000,
);

sub mayan_calendar_round {
    my $date = shift;
    tzolkin($date), haab($date);
}

sub offset {
    my $date = shift;
    Delta_Days( split('-', $correlation{'gregorian'}), split('-', $date) );
}

sub haab {
    my $date  = shift;
    my $index = ($correlation{'round'}[2] + offset $date) % 365;
    my ($day, $month);
    if ($index > 360) {
        $day = $index - 360;
        $month = $civil[18];
        if ($day == 5) {
            $day = 'Chum';
            $month = $civil[0];
        }
    } else {
        $day = $index % 20;
        $month = $civil[int $index / 20];
        if ($day == 0) {
            $day = 'Chum';
            $month = $civil[int (1 + $index) / 20];
        }
    }
    $day, $month
}

sub tzolkin {
    my $date   = shift;
    my $offset = offset $date;
    1 + ($offset + $correlation{'round'}[0]) % 13,
    $sacred[($offset + $correlation{'round'}[1]) % 20]
}

sub lord {
    my $date = shift;
    1 + ($correlation{'round'}[3] + offset $date) % 9
}

sub mayan_long_count {
    my $date = shift;
    my $days = $correlation{'long'} + offset $date;
    encode($days, [20,20,20,18,20]);
}

print <<'EOH';
 Gregorian   Tzolk’in         Haab’             Long           Lord of
   Date       # Name       Day Month            Count         the Night
-----------------------------------------------------------------------
EOH

for my $date (<1961-10-06 2004-06-19 2012-12-18 2012-12-21 2019-01-19 2019-03-27 2020-02-29 2020-03-01 2071-05-16>) {
    printf "%10s   %2s %-9s %4s %-10s     %-14s     G%d\n",
      $date, mayan_calendar_round($date), join('.',mayan_long_count($date)), lord($date);
}
