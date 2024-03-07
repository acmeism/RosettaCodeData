import "./fmt" for Fmt

var ownCalcPass = Fn.new { |password, nonce|
    var start = true
    var num1 = 0
    var num2 = 0
    var pwd = Num.fromString(password)
    for (c in nonce) {
        if (c != "0") {
            if (start) num2 = pwd
            start = false
        }
        if (c == "1") {
            num1 = (num2 & 0xFFFFFF80) >> 7
            num2 = num2 << 25
        } else if (c == "2") {
            num1 = (num2 & 0xFFFFFFF0) >> 4
            num2 = num2 << 28
        } else if (c == "3") {
            num1 = (num2 & 0xFFFFFFF8) >> 3
            num2 = num2 << 29
        } else if (c == "4") {
            num1 = num2 << 1
            num2 = num2 >> 31
        } else if (c == "5") {
            num1 = num2 << 5
            num2 = num2 >> 27
        } else if (c == "6") {
            num1 = num2 << 12
            num2 = num2 >> 20
        } else if (c == "7") {
            var num3 = num2 & 0x0000FF00
            var num4 = ((num2 & 0x000000FF) << 24) | ((num2 & 0x00FF0000) >> 16)
            num1 = num3 | num4
            num2 = (num2 & 0xFF000000) >> 8
        } else if (c == "8") {
            num1 = (num2&0x0000FFFF)<<16 | (num2 >> 24)
            num2 = (num2 & 0x00FF0000) >> 8
        } else if (c == "9") {
            num1 = ~num2
        } else {
            num1 = num2
        }
        num1 = num1 & 0xFFFFFFFF
        num2 = num2 & 0xFFFFFFFF
        if (c != "0" && c != "9") num1 = num1 | num2
        num2 = num1
    }
    return num1
}

var testPasswordCalc = Fn.new { |password, nonce, expected|
    var res = ownCalcPass.call(password, nonce)
    var m = Fmt.swrite("$s  $s  $-10d  $-10d", password, nonce, res, expected)
    if (res == expected) {
        System.print("PASS %(m)")
    } else {
        System.print("FAIL %(m)")
    }
}

testPasswordCalc.call("12345", "603356072", 25280520)
testPasswordCalc.call("12345", "410501656", 119537670)
testPasswordCalc.call("12345", "630292165", 4269684735)
