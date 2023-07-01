sub rom-to-num($r) {
    [+] gather $r.uc ~~ /
        ^
        [
        | M  { take 1000 }
        | CM { take 900 }
        | D  { take 500 }
        | CD { take 400 }
        | C  { take 100 }
        | XC { take 90 }
        | L  { take 50 }
        | XL { take 40 }
        | X  { take 10 }
        | IX { take 9 }
        | V  { take 5 }
        | IV { take 4 }
        | I  { take 1 }
        ]+
        $
    /;
}

say "$_ => &rom-to-num($_)" for <MCMXC MDCLXVI MMVIII>;
