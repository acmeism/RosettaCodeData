Red [
	Title:  "Compiler/Verifying syntax"
	Author: "hinjolicious"
]

sp: 	 [any space]
stmt:    [sp expr sp]
expr:    [expr2]
expr2:   [expr3 any [sp "or" sp expr3]]
expr3:   [expr4 any [sp "and" sp expr4]]
expr4:   [opt ["not" sp] expr5 opt [sp ["=" | "<"] sp expr5]]
expr5:   [expr6 any [sp ["+" | "-"] sp expr6]]
expr6:   [prim any [sp ["*" | "/"] sp prim]]
prim:    [sp [ ident | integer | ["(" sp expr sp ")"] | "true" | "false" ] sp]
ident:   [letter any [letter | digit | "_"]]
integer: [some digit]
digit:   charset "0123456789"
letter:  charset [#"a" - #"z" #"A" - #"Z"]

cnt: psd: 0
test: func [str c][
	cnt: cnt + 1
	r: parse str stmt
	print [str "->" r c "->" either r = c [psd: psd + 1 "passed!"]["FAILED!"]]]

; test
test "wombat" true
test "wombat or monotreme" true
test "( wombat and not )" false
test "wombat or not" false
test "a + 1" true
test "a + b < c" true
test "a + b - c * d / e < f and not ( g = h )" true
test "a + b - c * d / e < f and not ( g = h" false
test "a = b" true
test "a or b = c" true
test "$" false
test "true or false = not true" false
test "not true = false" true
test "3 + not 5" false
test "3 + (not 5)" true
test "(42 + 3" false
test " not 3 < 4 or (true or 3 / 4 + 8 * 5 - 5 * 2 < 56) and 4 * 3 < 12 or not true" true
test " and 3 < 2" false
test "not 7 < 2" true
test "2 < 3 < 4" false
test "2 < foobar - 3 < 4" false
test "2 < foobar and 3 < 4" true
test "4 * (32 - 16) + 9 = 73" true
test "235 76 + 1" false
test "a + b = not c and false" false
test "a + b = (not c) and false" true
test "a + b = (not c and false)" true
test "ab_c / bd2 or < e_f7" false
test "g not = h" false
test "été = false" false
test "i++" false
test "j & k" false
test "l or _m" false
print ["passed: " form/part psd / cnt * 100 5 "%"]
