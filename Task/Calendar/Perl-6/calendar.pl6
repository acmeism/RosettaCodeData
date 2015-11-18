my $months-per-col = 3;
my @week-day-names = <Mo Tu We Th Fr Sa Su>;
my @month-names = <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>;

my Int $year = +(@*ARGS.shift || 1969);

say fmt-year($year);
exit;

sub fmt-year ($year) {

        my $str = (' ' x 30) ~ $year ~ "\n";

        my Array @month-strs;
        @month-strs[$_] = fmt-month($year, $_).lines.Array for 1 .. 12;

        loop ( my $month = 1; $month <= 12; $month += $months-per-col ) {
                while @month-strs[$month] {
                        for ^$months-per-col {
                                next unless @month-strs[$month+$_];
                                $str ~= @month-strs[$month+$_].shift;
                                $str ~= " " x 3;
                        }
                        $str ~= "\n";
                }
                $str ~= "\n";
        }
        return $str;
}
sub fmt-month ($year, $month) {
        my $str = sprintf "%-20s\n", @month-names[$month-1];
        $str ~= @week-day-names~"\n";
        my $date = DateTime.new(year => $year, month => $month);
        my $week-day = $date.day-of-week;

        $str ~= ("  " xx $week-day-1).join(" ");

        for $date.day .. $date.days-in-month -> $day {

                $date = DateTime.new(year => $year, month => $month, day => $day);

                $str ~= " " if 1 < $week-day < 8;
                if $week-day == 8 {
                        $str ~= "\n";
                        $week-day = 1;
                }
                $str ~= sprintf "%2d", $day;

                $week-day++;
        }
        $str ~= " " if $week-day < 8;
        $str ~= ("  " xx 8-$week-day).join(" ");
        $str ~= "\n";
        return $str;
}
