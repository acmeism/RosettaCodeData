my $months-per-row = 3;
my @weekday-names  = <Mo Tu We Th Fr Sa Su>;
my @month-names    = <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>;

my Int() $year = @*ARGS.shift || 1969;
say fmt-year($year);

sub fmt-year ($year) {
    my @month-strs;
    @month-strs[$_] = [fmt-month($year, $_).lines] for 1 .. 12;
    my @C = ' ' x 30 ~ $year, '';
    for 1, 1+$months-per-row ... 12 -> $month {
        while @month-strs[$month] {
            for ^$months-per-row -> $column {
                @C[*-1] ~= @month-strs[$month+$column].shift ~ ' ' x 3 if @month-strs[$month+$column];
            }
            @C.push: '';
        }
        @C.push: '';
    }
    @C.join: "\n";
}

sub fmt-month ($year, $month) {
    my $date = Date.new($year,$month,1);
    @month-names[$month-1].fmt("%-20s\n") ~ @weekday-names ~ "\n" ~
    (('  ' xx $date.day-of-week - 1), (1..$date.days-in-month)».fmt('%2d')).flat.rotor(7, :partial).join("\n") ~
    (' ' if $_ < 7) ~ ('  ' xx 7-$_).join(' ') given Date.new($year, $month, $date.days-in-month).day-of-week;
}
