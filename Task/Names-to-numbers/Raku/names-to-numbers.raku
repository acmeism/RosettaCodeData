my $phrases-with-numbers = q:to/END/;
One Hundred and One Dalmatians
Two Thousand and One: A Space Odyssey

Four  Score  And  Seven  Years  Ago
twelve dozen is one hundred forty-four, aka one gross
two hundred pairs of socks
Always give one hundred and ten percent effort
Change due: zero dollars and thirty-seven cents

One hour, fifty-nine minutes, forty point two seconds
π ≅ three point one four one five nine
END

my $pure-numbers = q:to/END/;
Twenty Nineteen
Two Thousand Nineteen
Two Thousand Zero Hundred and Nineteen
Two Thousand Ten Nine

one thousand one
ninety nine thousand nine hundred ninety nine
five hundred and twelve thousand, six hundred and nine
two billion, one hundred

One Thousand One Hundred Eleven
Eleven Hundred Eleven
one hundred eleven billion one hundred eleven
Eight Thousand Eight Hundred Eighty-Eight
Eighty-Eight Hundred Eighty-Eight

Forty-two quintillion, one quadrillion, two trillion, three billion, four million, five thousand six
END

my %nums = (
    zero        => 0,     one        => 1,     two         => 2,     three    => 3,
    four        => 4,     five       => 5,     six         => 6,     seven    => 7,
    eight       => 8,     nine       => 9,     ten         => 10,    eleven   => 11,
    twelve      => 12,    thirteen   => 13,    fourteen    => 14,    fifteen  => 15,
    sixteen     => 16,    seventeen  => 17,    eighteen    => 18,    nineteen => 19,
    twenty      => 20,    thirty     => 30,    forty       => 40,    fifty    => 50,
    sixty       => 60,    seventy    => 70,    eighty      => 80,    ninety   => 90,
    hundred     => 100,   thousand   => 1_000, million     => 1_000_000,
    billion     => 1_000_000_000,              trillion    => 1_000_000_000_000,
    quadrillion => 1_000_000_000_000_000,      quintillion => 1_000_000_000_000_000_000
);

# groupings:     thousand million billion  trillion quadrillion quintillion
my token groups { \d**4  | \d**7 | \d**10 | \d**13 | \d**16    | \d**19 };

# remove hyphens/spaces: leading, trailing, multiple
sub squeeze ($str is copy) { $str ~~ s:g/'-' | \s+ / /; $str .=trim }

# commify larger numbers for readabilty
sub comma { $^i.chars > 4 ?? $^i.flip.comb(3).join(',').flip !! $^i }

sub numify ($str is copy) {
    $str = squeeze $str.lc;
    $str ~~ s:g/(.)(<punct>)/$0 $1/;

    for %nums.kv -> $word, $number { $str ~~ s:g/ <|w> $word <|w> / $number / }

    $str ~~ s:g/(\d+)<ws> <?before \d>/$0/ if $str ~~ /(point )<ws>[(\d)<ws>]+$/;
    $str ~~ s:g/(\d+) <ws> 'score' / {$0 * 20} /;
    $str ~~ s:g/(\d) <ws> [','|'and'] <ws> (\d)/$0 $1/;

    $str ~~ s:g/ <|w> (\d) <ws> 100 <ws> (\d\d) <ws> (\d) <ws>     (<groups>) <|w> / {($0 * 100 + $1 + $2) * $3} /;
    $str ~~ s:g/ <|w> (\d) <ws> 100 <ws> (\d ** 1..2)     <ws>     (<groups>) <|w> / {($0 * 100 + $1) * $2}      /;
    $str ~~ s:g/ <|w> (\d) <ws> 100                       <ws>     (<groups>) <|w> / { $0 * 100 * $1}            /;
    $str ~~ s:g/ <|w>      <ws> 100 <ws> (\d\d) <ws> (\d) <ws>     (<groups>) <|w> / {($0 + 100 + $1) * $2}      /;
    $str ~~ s:g/ <|w>      <ws> 100 <ws> (\d ** 1..2)     <ws>     (<groups>) <|w> / {($0 + 100     ) * $1}      /;
    $str ~~ s:g/ <|w>      <ws> 100                       <ws>     (<groups>) <|w> / { $0 * 100}                 /;
    $str ~~ s:g/ <|w>              (\d\d) <ws> (\d)       <ws>     (<groups>) <|w> / {($0 + $1) * $2}            /;
    $str ~~ s:g/ <|w>              (\d ** 1..2)           <ws>     (<groups>) <|w> / { $0 * $1}                  /;
    $str ~~ s:g/ <|w>              (\d\d) <ws> (\d)       <ws> 100            <|w> / {($0 + $1) * 100}           /;
    $str ~~ s:g/ <|w>              (\d ** 1..2)           <ws> 100            <|w> / { $0 * 100}                 /;
    $str ~~ s:g/ <|w>              (\d ** 2)<ws>(\d ** 2)                     <|w> / { $0 * 100 + $1}            /;

    $str ~~ s:g/( [\d+<ws>]* \d+ ) / {[+] $0.split: ' '} /;

    $str ~~ s:g/(\d+) <ws> 'pairs of'         /  {$0 *  2} /;
    $str ~~ s:g/(\d+) <ws> 'dozen'            /  {$0 * 12} /;
    $str ~~ s:g/(\d+) <ws> 'point' <ws> (\d+) /   $0.$1    /;
    $str ~~ s:g/(\d+) <ws> 'percent'          /   $0%      /;
    $str ~~ s:g/(\d+) <ws> 'dollars'          / \$$0       /;
    $str ~~ s:g/(\d+) <ws> 'cents'            /   $0¢      /;

    squeeze $str;
}

say $_ ~ ' --> ' ~ .&numify        for $phrases-with-numbers.split("\n").grep: *.so;
say $_ ~ ' --> ' ~ .&numify.&comma for         $pure-numbers.split("\n").grep: *.so;
