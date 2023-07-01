sub fractran(@program) {
    2, { first Int, map (* * $_).narrow, @program } ... 0
}
for fractran <17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11
        15/14 15/2 55/1> {
        say $++, "\t", .msb, "\t", $_ if 1 +< .msb == $_;
}
