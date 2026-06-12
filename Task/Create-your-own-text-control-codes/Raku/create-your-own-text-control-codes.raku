use Lingua::EN::Numbers;
use Acme::Text::UpsideDown;

sub printf (Str $format is copy, *@vars is copy) {
    my @directives = $format.comb(/ <?after <-[%]>|^> '%' <[ +0#-]>* <alpha>/);
    for ^@directives {
        if @directives[$_] eq '%y' {
            $format.=subst('%y', '%s');
            @vars[$_].=&comma;
        } elsif @directives[$_] eq '%z' {
            $format.=subst('%z', '%s');
            @vars[$_].=&upsidedown;
        }
    }
    &CORE::printf($format, @vars)
}

printf "Integer %d with commas: %y\nSpelled out: %s\nInverted: %z\n",
       12345, 12345, 12345.&cardinal, 12345.&cardinal;
