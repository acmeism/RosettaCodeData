    # $x can contain only Int objects
    my Int $x;

    # $x can only contain native integers (not integer objects)
    my int $x;

    #A variable may itself be bound to a container type that specifies how the container works, without specifying what kinds of things it contains.
    # $x is implemented by the MyScalar class
    my $x is MyScalar;

    #Constraints and container types can be used together:
    # $x can contain only Int objects,
    # and is implemented by the MyScalar class
    my Int $x is MyScalar;
