sub apply (&@) {            # use & as the first item in a prototype to take bare blocks like map and grep
    my ($sub, @ret) = @_;   # this function applies a function that is expected to modify $_ to a list
    $sub->() for @ret;      # it allows for simple inline application of the s/// and tr/// constructs
    @ret
}

print join ", " => apply {tr/aeiou/AEIOU/} qw/one two three four/;
# OnE, twO, thrEE, fOUr
