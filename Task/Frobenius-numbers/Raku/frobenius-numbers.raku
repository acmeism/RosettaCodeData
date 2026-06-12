say "{+$_} matching numbers\n{.batch(10)».fmt('%4d').join: "\n"}\n"
    given (^1000).grep( *.is-prime ).rotor(2 => -1)
    .map( { (.[0] * .[1] - .[0] - .[1]) } ).grep(* < 10000);
