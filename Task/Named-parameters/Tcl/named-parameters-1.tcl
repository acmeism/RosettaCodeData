proc example args {
    # Set the defaults
    array set opts {-foo 0 -bar 1 -grill "hamburger"}
    # Merge in the values from the caller
    array set opts $args
    # Use the arguments
    return "foo is $opts(-foo), bar is $opts(-bar), and grill is $opts(-grill)"
}
# Note that -foo is omitted and -grill precedes -bar
example -grill "lamb kebab" -bar 3.14
# => ‘foo is 0, bar is 3.14, and grill is lamb kebab’
