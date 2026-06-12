def go: [
        "$",
        "one",
        "either or both",
        "a + 1",
        "a + b < c",
        "a = b",
        "a or b = c",
        "3 + not 5",
        "3 + (not 5)",
        "(42 + 3",
        "(42 + 3)",
        " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
        " and 3 < 2",
        "not 7 < 2",
        "2 < 3 < 4",
        "2 < (3 < 4)",
        "2 < foobar - 3 < 4",
        "2 < foobar and 3 < 4",
        "4 * (32 - 16) + 9 = 73",
        "235 76 + 1",
        "true or false = not true",
        "true or false = (not true)",
        "not true or false = false",
        "not true = false",
        "a + b = not c and false",
        "a + b = (not c) and false",
        "a + b = (not c and false)",
        "ab_c / bd2 or < e_f7",
        "g not = h",
        "été = false",
        "i++",
        "j & k",
        "l or _m"
    ];

# For ease of comparison with the Go output, simply emit `true` or `false`
go[]
| (stmt | true) // false
