my $start = '1000-01-01';

my @palindate = {
     state $year = $start.substr(0,4);
     ++$year;
     my $m = $year.substr(2, 2).flip;
     my $d = $year.substr(0, 2).flip;
     next if not try Date.new("$year-$m-$d");
     "$year-$m-$d"
} … *;

my $date-today = Date.today; # 2020-02-02

my $k = @palindate.first: { Date.new($_) > $date-today }, :k;

say join "\n", @palindate[$k - 1 .. $k + 14];

say "\nTotal number of four digit year palindrome dates:\n" ~
my $four = @palindate.first( { .substr(5,1) eq '-' }, :k );
say "between {@palindate[0]} and {@palindate[$four - 1]}.";

my $five = @palindate.first: { .substr(6,1) eq '-' }, :k;

say "\nTotal number of five digit year palindrome dates:\n" ~
+@palindate[$four .. $five]
