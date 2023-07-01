# General case implementation of a "FizzBuzz" class.
# Defaults to standard FizzBuzz unless a new schema is passed in.
class FizzBuzz {
    has $.schema is rw = < 3 Fizz 5 Buzz >.hash;
    method filter (Int $this) {
        my $fb;
        for $.schema.sort: { +.key } -> $p { $fb ~= $this %% +$p.key ?? $p.value !! ''};
        return $fb || $this;
    }
}


# Sub implementing the specific requirements of the task.
sub GeneralFizzBuzz (Int $upto, @schema?) {
    my $ping = FizzBuzz.new;
    $ping.schema = @schema.hash if @schema;
    map { $ping.filter: $_ }, 1 .. $upto;
}

# The task
say 'Using: 20 ' ~ <3 Fizz 5 Buzz 7 Baxx>;
.say for GeneralFizzBuzz(20, <3 Fizz 5 Buzz 7 Baxx>);

say '';

# And for fun
say 'Using: 21 ' ~ <2 Pip 4 Squack 5 Pocketa 7 Queep>;
say join ', ', GeneralFizzBuzz(21, <2 Pip 4 Squack 5 Pocketa 7 Queep>);
