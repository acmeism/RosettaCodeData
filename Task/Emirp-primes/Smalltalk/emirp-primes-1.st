isEmirp :=
    [:p | |e|
        (e := p asString reversed asNumber) isPrime
        and:[ e ~= p ]
    ].
