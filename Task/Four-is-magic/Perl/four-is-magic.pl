use Lingua::EN::Numbers qw(num2en);

sub cardinal {
    my($n) = @_;
    (my $en = num2en($n)) =~ s/\ and|,//g;
    $en;
}

sub magic {
    my($int) = @_;
    my $str;
    while () {
       $str .= cardinal($int) . " is ";
       if ($int == 4) {
           $str .= "magic.\n";
           last
       } else {
           $int = length cardinal($int);
           $str .= cardinal($int) . ", ";
       }
   }
   ucfirst $str;
}

print magic($_) for 0, 4, 6, 11, 13, 75, 337, -164, 9_876_543_209;
