class HQ9Interpreter {
    has @!code;
    has $!accumulator;
    has $!pointer;

    method run ($code) {
        @!code = $code.comb;
        $!accumulator = 0;
        $!pointer = 0;
        while $!pointer < @!code {
            given @!code[$!pointer].lc {
                when 'h' { say 'Hello world!' }
                when 'q' { say @!code }
                when '9' { bob(99) }
                when '+' { $!accumulator++ }
                default  { note "Syntax error: Unknown command \"{@!code[$!pointer]}\"" }
            }
	    $!pointer++;
        }
    }
    sub bob ($beer is copy) {
        sub what  { "{$beer??$beer!!'No more'} bottle{$beer-1??'s'!!''} of beer" };
        sub where { 'on the wall' };
        sub drink { $beer--; "Take one down, pass it around," }
        while $beer {
            .say for "&what() &where(),", "&what()!",
                     "&drink()", "&what() &where()!", ''
        }
    }
}

# Feed it a command string:

my $hq9 = HQ9Interpreter.new;
$hq9.run("hHq+++Qq");
say '';
$hq9.run("Jhq.k+hQ");
