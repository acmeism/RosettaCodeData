sub rom-to-num($r) {
    [+] gather $r.uc ~~ /
        ^
        ( (C*)M { take 1000 - 100 * $0.chars } )*
        ( (C*)D { take  500 - 100 * $0.chars } )?
        ( (X*)C { take  100 -  10 * $0.chars } )*
        ( (X*)L { take   50 -  10 * $0.chars } )?
        ( (I*)X { take   10 -       $0.chars } )*
        ( (I*)V { take    5 -       $0.chars } )?
        (     I { take    1                  } )*
        [ $ || { return NaN } ]
    /;
}

say "$_ => ", rom-to-num($_) for <MCMXC mdclxvi MMViii IIXX ILL>;
