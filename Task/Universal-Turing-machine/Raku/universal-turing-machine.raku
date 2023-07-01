sub run_utm(:$state! is copy, :$blank!, :@rules!, :@tape = [$blank], :$halt, :$pos is copy = 0) {
    $pos += @tape if $pos < 0;
    die "Bad initial position" unless $pos ~~ ^@tape;

STEP: loop {
        print "$state\t";
        for ^@tape {
            my $v = @tape[$_];
            print $_ == $pos ?? "[$v]" !! " $v ";
        }
        print "\n";

        last if $state eq $halt;

        for @rules -> @rule {
            my ($s0, $v0, $v1, $dir, $s1) = @rule;
            next unless $s0 eq $state and @tape[$pos] eq $v0;

            @tape[$pos] = $v1;

            given $dir {
                when 'left' {
                    if $pos == 0 { unshift @tape, $blank }
                    else { $pos-- }
                }
                when 'right' {
                    push @tape, $blank if ++$pos >= @tape;
                }
            }

            $state = $s1;
            next STEP;

        }
        die 'No matching rules';
    }

}

say "incr machine";
run_utm	:halt<qf>,
    :state<q0>,
    :tape[1,1,1],
    :blank<B>,
    :rules[
        [< q0 1 1 right q0 >],
        [< q0 B 1 stay  qf >]
    ];

say "\nbusy beaver";
run_utm :halt<halt>,
    :state<a>,
    :blank<0>,
    :rules[
        [< a 0 1 right b >],
        [< a 1 1 left  c >],
        [< b 0 1 left  a >],
        [< b 1 1 right b >],
        [< c 0 1 left  b >],
        [< c 1 1 stay  halt >]
    ];

say "\nsorting test";
run_utm :halt<STOP>,
    :state<A>,
    :blank<0>,
    :tape[< 2 2 2 1 2 2 1 2 1 2 1 2 1 2 >],
    :rules[
        [< A 1 1 right A >],
        [< A 2 3 right B >],
        [< A 0 0 left  E >],
        [< B 1 1 right B >],
        [< B 2 2 right B >],
        [< B 0 0 left  C >],
        [< C 1 2 left  D >],
        [< C 2 2 left  C >],
        [< C 3 2 left  E >],
        [< D 1 1 left  D >],
        [< D 2 2 left  D >],
        [< D 3 1 right A >],
        [< E 1 1 left  E >],
        [< E 0 0 right STOP >]
    ];
