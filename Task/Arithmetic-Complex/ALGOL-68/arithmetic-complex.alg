main:(
  FORMAT compl fmt = $g(-7,5)"⊥"g(-7,5)$;

  PROC compl operations = VOID: (
    LONG COMPL a = 1.0 ⊥ 1.0;
    LONG COMPL b = 3.14159 ⊥ 1.2;

    LONG COMPL c;

    printf(($x"a="f(compl fmt)l$,a));
    printf(($x"b="f(compl fmt)l$,b));

    # addition #
    c := a + b;
    printf(($x"a+b="f(compl fmt)l$,c));
    # multiplication #
    c := a * b;
    printf(($x"a*b="f(compl fmt)l$,c));
    # inversion #
    c := 1.0 / a;
    printf(($x"1/c="f(compl fmt)l$,c));
    # negation #
    c := -a;
    printf(($x"-a="f(compl fmt)l$,c))
  );
  compl operations
)
