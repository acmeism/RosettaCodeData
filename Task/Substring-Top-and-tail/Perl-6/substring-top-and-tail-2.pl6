my $string = 'ouch';
say $string.chop;   # ouc - does not modify original $string
say $string;        # ouch
say $string.p5chop; # h   - returns the character chopped off and modifies $string
say $string;        # ouc
