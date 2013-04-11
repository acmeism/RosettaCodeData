sub bool ($a, $b) {
    say 'Coerce to Boolean';
    say_bool_buff "$a and $b", $a ?& $b;
    say_bool_buff "$a or $b",  $a ?| $b;
    say_bool_buff "$a xor $b", $a ?^ $b;
    say_bool_buff "not $a", !$a;
}

sub buf ($a, $b) {
    say 'Coerce to Buffer';
    say_bool_buff "$a and $b", $a ~& $b;
    say_bool_buff "$a or $b",  $a ~| $b;
    say_bool_buff "$a xor $b", $a ~^ $b;
#   say_bool_buff "$a bit shift right $b", $a ~> $b; #NYI in Rakudo
#   say_bool_buff "$a bit shift left $b", $a ~< $b;  #NYI in Rakudo
}

sub int ($a, $b) {
    say 'Coerce to Int';
    say_bit "$a and $b", $a +& $b;
    say_bit "$a or $b",  $a +| $b;
    say_bit "$a xor $b", $a +^ $b;
    say_bit "$a signed bit shift right $b", $a +> $b;
#   say_bit "$a unsigned bit shift right $b", $a +> $b :unsigned; #NYI in Rakudo
#   say_bit "$a rotate right $b", $a +> $b :rotate;               #NYI in Rakudo
    say_bit "$a bit shift left $b", $a +< $b;
#   say_bit "$a rotate shift left $b", $a +< $b :rotate;          #NYI in Rakudo
    say_bit "twos complement not $a", +^$a;

}

bool(7,2);
say '-' x 80;
buf(7,2);
say '-' x 80;
int(7,2);
say '-' x 80;


sub say_bit ($message, $value) {
    my $INTSIZE = $*VM{'config'}{'intvalsize'} * 8; # hack to get native Int size
    printf("%30s: %4d, %032b\n", $message, $value, $value) if $INTSIZE == 32;
    printf("%30s: %4d, %064b\n", $message, $value, $value) if $INTSIZE == 64;
}

sub say_bool_buff ($message, $value) {
    printf("%30s: %4d, %s\n", $message, $value, $value);
}
