var statements = Array(count: 13, repeatedValue: false)
statements[1] = true
var count = 0

func check2() -> Bool {
    var count = 0
    for (var k = 7; k <= 12; k++) {
        if (statements[k]) {
            count++
        }
    }
    return statements[2] == (count == 3)
}

func check3() -> Bool {
    var count = 0
    for (var k = 2; k <= 12; k += 2) {
        if (statements[k]) {
            count++
        }
    }
    return statements[3] == (count == 2)
}

func check4() -> Bool {
    return statements[4] == (!statements[5] || statements[6] && statements[7])
}

func check5() -> Bool {
    return statements[5] == (!statements[2] && !statements[3] && !statements[4])
}

func check6() -> Bool {
    var count = 0
    for (var k = 1; k <= 11; k += 2) {
        if (statements[k]) {
            count++
        }
    }
    return statements[6] == (count == 4)
}

func check7() -> Bool {
    return statements[7] == ((statements[2] || statements[3]) && !(statements[2] && statements[3]))
}

func check8() -> Bool {
    return statements[8] == ( !statements[7] || statements[5] && statements[6])
}

func check9() -> Bool {
    var count = 0
    for (var k = 1; k <= 6; k++) {
        if (statements[k]) {
            count++
        }
    }
    return statements[9] == (count == 3)
}

func check10() -> Bool {
    return statements[10] == (statements[11] && statements[12])
}

func check11() -> Bool {
    var count = 0
    for (var k = 7; k <= 9; k++) {
        if (statements[k]) {
            count++
        }
    }

    return statements[11] == (count == 1)
}

func check12() -> Bool {
    var count = 0
    for (var k = 1; k <= 11; k++) {
        if (statements[k]) {
            count++
        }
    }
    return statements[12] == (count == 4)
}

func check() {
    if (check2() && check3() && check4() && check5() && check6()
        && check7() && check8() && check9() && check10() && check11()
        && check12()) {
            for (var k = 1; k <= 12; k++) {
                if (statements[k]) {
                    print("\(k) ")
                }
            }
            println()
            count++
    }
}

func checkAll(k:Int) {
    if (k == 13) {
        check()
    } else {
        statements[k] = false
        checkAll(k + 1)
        statements[k] = true
        checkAll(k + 1)
    }
}

checkAll(2)
println()
println("\(count) solutions found")
