my @abbr = < Nil Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec >;

my @holidays =
    Easter    => 0,
    Ascension => 39,
    Pentecost => 49,
    Trinity   => 56,
    Corpus    => 60;

sub easter($year) {
    my \ay = $year % 19;
    my \by = $year div 100;
    my \cy = $year % 100;
    my \dy = by div 4;
    my \ey = by % 4;
    my \fy = (by + 8) div 25;
    my \gy = (by - fy + 1) div 3;
    my \hy = (ay * 19 + by - dy - gy + 15) % 30;
    my \iy = cy div 4;
    my \ky = cy % 4;
    my \ly = (32 + 2 * ey + 2 * iy - hy - ky) % 7;
    my \md = hy + ly - 7 * ((ay + 11 * hy + 22 * ly) div 451) + 114;
    my \month = md div 31;
    my \day = md % 31 + 1;

    return month, day;
}

sub cholidays($year) {
    my ($emon, $eday) = easter($year);
    printf "%4s: ", $year;
    say join ', ', gather for @holidays -> $holiday {
	my $d = Date.new($year,$emon,$eday) + $holiday.value;
	take "{$holiday.key}: $d.day-of-month.fmt('%02s') @abbr[$d.month]";
    }
}

for flat (400,500 ... 2000), (2010 ... 2020), 2100 -> $year {
    cholidays($year);
}
