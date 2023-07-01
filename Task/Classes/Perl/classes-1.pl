{
     # a class is a package (i.e. a namespace) with methods in it
    package MyClass;

     # a constructor is a function that returns a blessed reference
    sub new {
        my $class = shift;
        bless {variable => 0}, $class;
         # the instance object is a hashref in disguise.
         # (it can be a ref to anything.)
    }

     # an instance method is a function that takes an object as first argument.
     # the -> invocation syntax takes care of that nicely, see Usage paragraph below.
    sub some_method {
        my $self = shift;
        $self->{variable} = 1;
    }
}
