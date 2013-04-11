STRUCT: foo { a int } { b foo* } ;

[
    foo malloc-struct &free ! gets freed at end of the current with-destructors scope
    ! do stuff
] with-destructors
