my $object = "a string";  # Everything is an object.
my method example-method {
    return "This is { self }.";
}

say $object.&example-method;  # Outputs "This is a string."
