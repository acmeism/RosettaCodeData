BEGIN

  PROC compl operations = VOID: (
    COMPL a = 1.0 I 1.0;
    COMPL b = 3.14159 I 1.2;

    COMPL c;

    PROC show compl = ( STRING legend, COMPL v )VOID:
         print( ( legend, fixed( re OF v, -8, 5 ), " I ", fixed( im OF v, -8, 5 ), newline ) );

    show compl("  a=",a);
    show compl("  b=",b);

    # addition #
    c := a + b;
    show compl("a+b=",c);
    # multiplication #
    c := a * b;
    show compl("a*b=",c);
    # inversion #
    c := 1.0 / a;
    show compl("1/c=",c);
    # negation #
    c := -a;
    show compl(" -a=",c)
  );
  compl operations
END
