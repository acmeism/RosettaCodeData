constant @t = < ⡎⢉⢵ ⠀⢺⠀ ⠊⠉⡱ ⠊⣉⡱ ⢀⠔⡇ ⣏⣉⡉ ⣎⣉⡁ ⠊⢉⠝ ⢎⣉⡱ ⡎⠉⢱ ⠀⠶⠀>;
constant @b = < ⢗⣁⡸ ⢀⣸⣀ ⣔⣉⣀ ⢄⣀⡸ ⠉⠉⡏ ⢄⣀⡸ ⢇⣀⡸ ⢰⠁⠀ ⢇⣀⡸ ⢈⣉⡹ ⠀⠶⠀>;

signal(SIGINT).tap: { print "\e[?25h\n"; exit }
print "\e7\e[?25l"; # saves cursor position, make it invisible
loop {
    my @x = DateTime.now.Str.substr(11,8).ords X- ord('0');
    put ~.[@x] for @t, @b;
    sleep 1;
    print "\e8"; # restores cursor position
}
