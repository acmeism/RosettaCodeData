my (@mem, $ip, $acc); # memory, instruction pointer, accumulator

sub load (@program) {
    die "memory exceeded" if +@program > 32;
    $ip = 0;
    $acc = 0;
    @mem = @program »%» 256;
}

sub execute (*@program) {
    load @program;
    loop {
        my $reg = @mem[$ip];
        quietly my ($inst, $data) = $reg +> 5 +& 7, $reg +& 31;
        given $inst {
            when 0 { #`{ NOP } }
            when 1 { #`{ LDA } $acc = @mem[$data] }
            when 2 { #`{ STA } @mem[$data] = $acc }
            when 3 { #`{ ADD } $acc += @mem[$data] }
            when 4 { #`{ SUB } $acc -= @mem[$data] }
            when 5 { #`{ BRZ } $ip = $data - 1 unless $acc }
            when 6 { #`{ JMP } $ip = $data - 1 }
            when 7 { #`{ STP } last }
            default { die 'Invalid instruction' }
        }
        ++$ip;
        last if $ip == 32;
    }
    $acc
}

say "2 + 2 = " ~ execute 35,100,224,2,2;
say "7 x 8 = " ~ execute 44,106,76,43,141,75,168,192,44,224,8,7,0,1;
say "Fibonacci: " ~
execute 46,79,109,78,47,77,48,145,171,80,192,46,224,1,1,0,8,1;
say "Linked list: " ~
execute 45,111,69,112,71,0,78,0,171,79,192,46,
224,32,0,28,1,0,0,0,6,0,2,26,5,20,3,30,1,22,4,24;
say "Prisoners dilemma: " ~
execute 0,0,224,0,35,157,178,35,93,174,33,127,65,194,
32,127,64,194,35,93,33,126,99,65,32,126,99,64,194,0,1,3;
