my @sacred = <Imix’ Ik’ Ak’bal K’an Chikchan Kimi Manik’ Lamat Muluk Ok
              Chuwen Eb Ben Hix Men K’ib’ Kaban Etz’nab’ Kawak Ajaw>;

my @civil = <Pop Wo’ Sip Sotz’ Sek Xul Yaxk’in Mol Ch’en Yax Sak’ Keh
             Mak K’ank’in Muwan’ Pax K’ayab Kumk’u Wayeb’>;

my %correlation = :GMT({
    :gregorian(Date.new('2012-12-21')),
    :round([3,19,263,8]),
    :long(1872000)
});

sub mayan-calendar-round ($date) { .&tzolkin, .&haab given $date }

sub offset ($date, $factor = 'GMT') { Date.new($date) - %correlation{$factor}<gregorian> }

sub haab ($date, $factor = 'GMT') {
    my $index = (%correlation{$factor}<round>[2] + offset $date) % 365;
    my ($day, $month);
    if $index > 360 {
        $day = $index - 360;
        $month = @civil[18];
        if $day == 5 {
            $day = 'Chum';
            $month = @civil[0];
        }
    } else {
        $day = $index % 20;
        $month = @civil[$index div 20];
        if $day == 0 {
            $day = 'Chum';
            $month = @civil[(1 + $index) div 20];
        }
    }
    $day, $month
}

sub tzolkin ($date, $factor = 'GMT') {
    my $offset = offset $date;
    1 + ($offset + %correlation{$factor}<round>[0]) % 13,
    @sacred[($offset + %correlation{$factor}<round>[1]) % 20]
}

sub lord ($date, $factor = 'GMT') {
    'G' ~ 1 + (%correlation{$factor}<round>[3] + offset $date) % 9
}

sub mayan-long-count ($date, $factor = 'GMT') {
    my $days = %correlation{$factor}<long> + offset $date;
    reverse $days.polymod(20,18,20,20);
}

# HEADER
say ' Gregorian   Tzolk’in         Haab’             Long           Lord of ';
say '   Date       # Name       Day Month            Count         the Night';
say '-----------------------------------------------------------------------';

# DATES
<
1963-11-21
2004-06-19
2012-12-18
2012-12-21
2019-01-19
2019-03-27
2020-02-29
2020-03-01
2071-05-16
>.map: -> $date {
    printf "%10s   %2s %-9s %4s %-10s     %-14s %6s\n", Date.new($date),
      flat mayan-calendar-round($date), mayan-long-count($date).join('.'), lord($date);
}
