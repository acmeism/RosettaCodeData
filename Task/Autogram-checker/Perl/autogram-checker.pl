use v5.36;
use experimental <builtin for_list>;
use Sub::Util 'subname';
use List::Util 'sum';

my %nums = (
'zero' => 0, 'single' => 1, 'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5, 'six' => 6,
'seven' => 7, 'eight' => 8, 'nine' => 9, 'ten' => 10, 'eleven' => 11, 'twelve' => 12, 'thirteen' => 13,
'fourteen' => 14, 'fifteen' => 15, 'sixteen' => 16, 'seventeen' => 17, 'eighteen' => 18, 'nineteen' => 19,
'twenty' => 20, 'thirty' => 30, 'forty' => 40, 'fifty' => 50, 'sixty' => 60, 'seventy' => 70, 'eighty' => 80,
'ninety' => 90, 'hundred' => 100,
);

my @tests = (
    \&punctuation, "This sentence employs two a's, two c's, two d's, twenty-eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty-five s's, twenty-three t's, six v's, ten w's, two x's, five y's, and one z.",
    \&punctuation, "This sentence employs two a's, two c's, two d's, twenty eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's, ten w's, two x's, five y's, and one z.",
    '',            "Only the fool would take trouble to verify that his sentence was composed of ten a's, three b's, four c's, four d's, forty-six e's, sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's, four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's, forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's, eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens and, last but not least, a single !",
    \&punctuation, "This pangram contains four as, one b, two cs, one d, thirty es, six fs, five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns, fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us, seven vs, eight ws, two xs, three ys, & one z.",
    \&punctuation, "This sentence contains one hundred and ninety-seven letters: four a's, one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's, twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's, nineteen t's, six u's, seven v's, four w's, four x's, five y's, and one z.",
    \&punctuation, "Thirteen e's, five f's, two g's, five h's, eight i's, two l's, three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's, six w's, four x's, two y's.",
    '',            "Fifteen e's, seven f's, four g's, six h's, eight i's, four n's, five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's, three x's.",
    \&punctuation, "Sixteen e's, five f's, three g's, six h's, nine i's, five n's, four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's, four z's."
);

sub punctuation ($text) { $text =~ s/\W//grx }
sub wrap { (shift) =~ s/(.{96}.*?\s)/$1\n/gr }

for my($filter, $text) (@tests) {
    my(%Claim, %Actual, $count_claim, $count_actual);
    my %Punc = ('apostrophe' => "'", 'hyphen' => '-', 'comma' => ',', 'exclamation' => '!');
    my $str = my $filtered = my $original = lc $text;
    $str =~ s/\!/exclamation/g;

    say wrap $text;
    my $filter_func = $filter ? subname( $filter ) =~ s/main:://r : '';
    say "\nNOT filtering out punctuation" unless $filter_func;

    $str =~ s/\bone ([a-z])[,.]\b/one $1's,/g;
    for my($word, $number) (%nums) { $str =~ s/ \b $word \b /$number/gix }
    $str =~ s/(\d0)[ \-](\d)/$1 + $2/gxe;
    $str =~ s/\b1 100 and (\d+)\b/100 + $1/e;
    $str =~ s/(\d+) ([a-z])['s,.]*\b/ $Claim{$2} = $1/ge;

    $filtered = &$filter($original) if $filter;
    $Actual{$_} = () = $filtered =~ /$_/g for keys %Claim;
    $count_claim  .= "$_($Claim{$_}) "  for sort keys %Claim;
    $count_actual .= "$_($Actual{$_}) " for sort keys %Actual;

    unless ($filter_func) {
        for (sort keys %Punctuation) {
            $str =~ m/(\d+) ($_)/;
            $count_claim  .= "$Punctuation{$2}($1) " if $1 and $Punctuation{$2};
            my $n = () = $filtered =~ /$Punctuation{$_}/g;
            $count_actual .= "$Punctuation{$_}($n) " if $n;
        }
    }

    say "\nClaimed character counts:\n" . wrap $count_claim;
    say "\nActual character counts:\n"  . wrap $count_actual;

    say "\nAutogram? ". (my $AG = $count_claim eq $count_actual ? 'True' : 'False');
    say "Autogram? " . ($AG and $1 == $orig =~ tr/a-z// ? 'True' : 'False') . ' (with added sentence length condition)'
        if $str =~ /(\d+) letters/;
    say "\n" . '=' x 101;
}
