my @dates =
    { :15day, :5month },
    { :16day, :5month },
    { :19day, :5month },
    { :17day, :6month },
    { :18day, :6month },
    { :14day, :7month },
    { :16day, :7month },
    { :14day, :8month },
    { :15day, :8month },
    { :17day, :8month }
;

# Month can't have a unique day
my @filtered = @dates.grep(*.<month> != one(@dates.grep(*.<day> == one(@dates».<day>))».<month>));

# Day must be unique and unambiguous in remaining months
my $birthday = @filtered.grep(*.<day> == one(@filtered».<day>)).classify({.<month>})\
    .first(*.value.elems == 1).value[0];

# convenience array
my @months = <'' January February March April May June July August September October November December>;

say "Cheryl's birthday is { @months[$birthday<month>] } {$birthday<day>}.";
