class X::OutOfInk is Exception {
    method message() { "Printer out of ink" }
}

class Printer {
    has Str      $.id;
    has Int      $.ink = 5;
    has Lock     $!lock .= new;
    has ::?CLASS $.fallback;

    method print ($line) {
        $!lock.protect: {
            if    $!ink      { say "$!id: $line"; $!ink-- }
            elsif $!fallback { $!fallback.print: $line }
            else             { die X::OutOfInk.new }
        }
    }
}

my $printer =
    Printer.new: id => 'main', fallback =>
    Printer.new: id => 'reserve';

sub client ($id, @lines) {
    start {
        for @lines {
            $printer.print: $_;
            CATCH {
                when X::OutOfInk { note "<$id stops for lack of ink>"; exit }
            }
        }
        note "<$id is done>";
    }
}

await
    client('Humpty', q:to/END/.lines),
        Humpty Dumpty sat on a wall.
        Humpty Dumpty had a great fall.
        All the king's horses and all the king's men,
        Couldn't put Humpty together again.
        END
    client('Goose', q:to/END/.lines);
        Old Mother Goose,
        When she wanted to wander,
        Would ride through the air,
        On a very fine gander.
        Jack's mother came in,
        And caught the goose soon,
        And mounting its back,
        Flew up to the moon.
        END
