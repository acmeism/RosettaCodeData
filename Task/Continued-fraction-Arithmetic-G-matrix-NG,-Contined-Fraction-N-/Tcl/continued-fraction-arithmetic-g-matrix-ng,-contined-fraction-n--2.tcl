# The square root of 2 as a continued fraction in the framework
oo::class create Root2 {
    superclass Generator
    method apply {} {
	yield 1
	while {[self] ne ""} {
	    yield 2
	}
    }
}

set op [[NG1 new 2 1 0 2] operand [R2CF new 13/11]]
printcf "\[1;5,2\] + 1/2" $op

set op [[NG1 new 7 0 0 22] operand [R2CF new 22/7]]
printcf "\[3;7\] * 7/22" $op

set op [[NG1 new 2 1 0 2] operand [R2CF new 22/7]]
printcf "\[3;7\] + 1/2" $op

set op [[NG1 new 1 0 0 4] operand [R2CF new 22/7]]
printcf "\[3;7\] / 4" $op

set op [[NG1 new 0 1 1 0] operand [Root2 new]]
printcf "1/\u221a2" $op 20

set op [[NG1 new 1 1 0 2] operand [Root2 new]]
printcf "(1+\u221a2)/2" $op 20
printcf "approx val" [R2CF new 24142136 20000000]
