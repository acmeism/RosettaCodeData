use Regexp::Common 'RE_balanced';
sub balanced {
    return shift =~ RE_balanced(-parens=>'[]')
}
