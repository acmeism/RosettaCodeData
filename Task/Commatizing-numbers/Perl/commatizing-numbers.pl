@input = (
    ['pi=3.14159265358979323846264338327950288419716939937510582097494459231', ' ', 5],
    ['The author has two Z$100000000000000 Zimbabwe notes (100 trillion).', '.'],
    ['-in Aus$+1411.8millions'],
    ['===US$0017440 millions=== (in 2000 dollars)'],
    ['123.e8000 is pretty big.'],
    ['The land area of the earth is  57268900(29% of the surface)  square miles.'],
    ['Ain\'t no numbers in this here words, nohow, no way, Jose.'],
    ['James was never known as  0000000007'],
    ['Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.'],
    ['   $-140000±100  millions.'],
    ['5/9/1946 was a good year for some.']
);

for $i (@input) {
    $old = @$i[0];
    $new = commatize(@$i);
    printf("%s\n%s\n\n", $old, $new) if $old ne $new;
}

sub commatize {
    my($str,$sep,$by) = @_;
    $sep = ',' unless $sep;
    $by  = 3   unless $by;

    $str =~ s/                      # matching rules:
            (?<![eE\/])             #   not following these characters
            ([1-9]\d{$by,})         #   leading non-zero digit, minimum number of digits required
            /c_ins($1,$by,$sep)/ex; # substitute matched text with subroutine output
    return $str;
}

sub c_ins {
    my($s,$by,$sep) = @_;
    ($c = reverse $s) =~ s/(.{$by})/$1$sep/g;
    $c =~ s/$sep$//;
    return reverse $c;
}
