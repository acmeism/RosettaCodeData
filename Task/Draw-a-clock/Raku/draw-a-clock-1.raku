my ($rows,$cols) = qx/stty size/.words;
my $v = floor $rows / 2;
my $h = floor $cols / 2 - 16;

my @t = < ⡎⢉⢵ ⠀⢺⠀ ⠊⠉⡱ ⠊⣉⡱ ⢀⠔⡇ ⣏⣉⡉ ⣎⣉⡁ ⠊⢉⠝ ⢎⣉⡱ ⡎⠉⢱ ⠀⠶⠀>;
my @b = < ⢗⣁⡸ ⢀⣸⣀ ⣔⣉⣀ ⢄⣀⡸ ⠉⠉⡏ ⢄⣀⡸ ⢇⣀⡸ ⢰⠁⠀ ⢇⣀⡸ ⢈⣉⡹ ⠀⠶⠀>;

loop {
    my @x = DateTime.now.Str.substr(11,8).ords X- ord('0');
    print "\e[H\e[J";
    print "\e[$v;{$h}H";
    print ~@t[@x];
    print "\e[{$v+1};{$h}H";
    print ~@b[@x];
    print "\e[H";
    sleep 1;
}
