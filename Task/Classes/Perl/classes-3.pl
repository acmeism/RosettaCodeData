use MooseX::Declare;
class MyClass {
    has 'variable' => (is => 'rw', default => 0);
    method some_method {
        $self->variable(1);
    }
}
