put "{+$_} such numbers:\n", .batch(20)».fmt('%3d').join("\n")
    given (1..500).grep( { so any |.map: { .polymod(16 xx *) »>» 9 } } );
