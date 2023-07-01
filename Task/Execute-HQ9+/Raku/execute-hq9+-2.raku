my $hq9 = HQ9Interpreter.new;
while 1 {
    my $in = prompt('HQ9+>').chomp;
    last unless $in.chars;
    $hq9.run($in)
}
