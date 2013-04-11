my $x = 2; # Single-line comment.

#`(
    Comments beginning with a backtick and one or more
    opening bracketing characters are embedded comments.
    They can span more than one line…
)

my $y = #`{ …or only part of a line. } 3;

#`{{
    Using more than one bracketing character lets you include
    an unmatched close bracket, like this: }
}}

#`⁅ Synopsis 2: "Bracketing characters are defined as any
    Unicode characters with either bidirectional mirrorings or
    Ps/Pe/Pi/Pf properties." ⁆

=begin comment

Pod is the successor to Perl 5's POD. This is the simplest way
to use it for multi-line comments. For more about Pod, see
Synopsis 26:

http://perlcabal.org/syn/S26.html

=end comment
