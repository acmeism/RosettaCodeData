use strict;
use warnings;

my $test = <<END;
Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
'Tis very tomish, don't you think?
END

sub redact {
    my($str, $redact, %opt) = @_;
    my $insensitive = $opt{'i'} or 0;
    my $partial     = $opt{'p'} or 0;
    my $overkill    = $opt{'o'} or 0;

    my $rx =
        $insensitive ?
            $partial ?
           $overkill ? qr/ \b{wb} ((?i)[-\w_]* [\w*']* $redact [-'\w]* \S*?) \b{wb} /x
                     : qr/ ((?i)$redact) /x
                     : qr/ \b{wb}(?<!-) ((?i)$redact) (?!-)\b{wb} /x
                     :
            $partial ?
           $overkill ? qr/ \b{wb} ([-\w]* [\w*']* $redact [-'\w]* \S*?) \b{wb} /x
                     : qr/ ($redact) /x
                     : qr/ \b{wb}(?<!-) ($redact) (?!-)\b{wb} /x
    ;
    $str =~ s/($rx)/'X' x length $1/gre;
}

for my $redact (<Tom tom t>) {
    print "\nRedact '$redact':\n";
     for (['[w|s|n]', {}],
          ['[w|i|n]', {i=>1}],
          ['[p|s|n]', {p=>1}],
          ['[p|i|n]', {p=>1, i=>1}],
          ['[p|s|o]', {p=>1, o=>1}],
          ['[p|i|o]', {p=>1, i=>1, o=>1}]
         ) {
            my($option, $opts) = @$_;
            no strict 'refs';
            printf "%s %s\n", $option, redact($test, $redact, %$opts)
        }
}
