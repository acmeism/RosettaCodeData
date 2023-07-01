#!/usr/bin/env raku
unit sub MAIN($birthday=%*ENV<BIRTHDAY>, $date = Date.today()) {

my %cycles = ( :23Physical, :28Emotional, :33Mental );
my @quadrants = [ ('up and rising',    'peak'),
                  ('up but falling',   'transition'),
                  ('down and falling', 'valley'),
                  ('down but rising',  'transition') ];

if !$birthday {
    die "Birthday not specified.\n" ~
        "Supply --birthday option or set \$BIRTHDAY in environment.\n";
}

my ($bday, $target) = ($birthday, $date).map: { Date.new($_) };
my $days = $target - $bday;

say "Day $days:";
for %cycles.sort(+*.value)».kv -> ($label, $length) {
    my $position = $days % $length;
    my $quadrant = floor($position / $length * 4);
    my $percentage = floor(sin($position / $length * 2 * π )*1000)/10;
    my $description;
    if $percentage > 95 {
        $description = 'peak';
    } elsif $percentage < -95 {
        $description = 'valley';
    } elsif abs($percentage) < 5 {
        $description = 'critical transition'
    } else {
        my $transition = $target + floor(($quadrant + 1)/4 * $length) - $position;
        my ($trend, $next) = @quadrants[$quadrant];
        $description = "$percentage% ($trend, next $next $transition)";
    }
    say "$label day $position: $description";
  }
}
