# this is file narc.pl
print do { local $/; open 0, $0 or die $!; <0> } eq <> ? "accept" : "reject"
