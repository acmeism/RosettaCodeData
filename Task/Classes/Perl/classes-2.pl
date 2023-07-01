{
    package MyClass;
    use Moose;

    has 'variable' => (is => 'rw', default => 0);
    # constructor and accessor methods are added automatically

    sub some_method {
        my $self = shift;
        $self->variable(1);
    }
}
