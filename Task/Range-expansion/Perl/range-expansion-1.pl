sub rangex {
    map { /^(.*\d)-(.+)$/ ? $1..$2 : $_ } split /,/, shift
}

# Test and display
print join(',', rangex('-6,-3--1,3-5,7-11,14,15,17-20')), "\n";
