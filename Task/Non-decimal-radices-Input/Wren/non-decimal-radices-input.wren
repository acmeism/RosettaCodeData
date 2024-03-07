import "./fmt" for Conv, Fmt

var tests = [ ["0b1110", 2], ["112", 3], ["0o16", 8], ["14", 10], ["0xe", 16], ["e", 19] ]
for (test in tests) {
    Fmt.print("$6s in base $-2d = $s", test[0], test[1], Conv.atoi(test[0], test[1]))
}
