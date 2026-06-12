sub repeat ( Int $repeat where * > 1, Str $message, --> Str ) {
    say $message x $repeat;
    True # wrong return type
}

repeat( 2, 'A' ); # parameters ok, return type check error

repeat( 4, 2 ); # wrong second parameter type

repeat( 'B', 3 ); # wrong first (and second) parameter type

repeat( 1, 'C' ); # constraint check fail

repeat( ); # wrong number of parameters

CATCH {
    default {
        say "Error trapped: $_";
        .resume;
    }
}
