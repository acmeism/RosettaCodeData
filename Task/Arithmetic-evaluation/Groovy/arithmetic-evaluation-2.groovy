def testParse = {
    def ex = parse(it)
    print """
Input: ${it}
AST:   ${ex}
value: ${ex.evaluate()}
"""
}


testParse('1+1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+1/15)/14)/13)/12)/11)/10)/9)/8)/7)/6)/5)/4)/3)/2')
assert (parse('1+1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+1/15)/14)/13)/12)/11)/10)/9)/8)/7)/6)/5)/4)/3)/2')
        .evaluate() - Math.E).abs() < 0.0000000000001
testParse('1 + 2*(3 - 2*(3 - 2)*((2 - 4)*5 - 22/(7 + 2*(3 - 1)) - 1)) + 1')
testParse('1 - 5 * 2 / 20 + 1')
testParse('(1 - 5) * 2 / (20 + 1)')
testParse('2 * (3 + ((5) / (7 - 11)))')
testParse('(2 + 3) / (10 - 5)')
testParse('(1 + 2) * 10 / 100')
testParse('(1 + 2 / 2) * (5 + 5)')
testParse('2*-3--4+-.25')
testParse('2*(-3)-(-4)+(-.25)')
testParse('((11+15)*15)*2-(3)*4*1')
testParse('((11+15)*15)* 2 + (3) * -4 *1')
testParse('(((((1)))))')
testParse('-35')
println()

try { testParse('((11+15)*1') } catch (e) { println e }
try { testParse('((11+15)*1)))') } catch (e) { println e }
try { testParse('((11+15)*x)') } catch (e) { println e }
try { testParse('+++++') } catch (e) { println e }
try { testParse('1 /') } catch (e) { println e }
try { testParse('1++') } catch (e) { println e }
try { testParse('*1') } catch (e) { println e }
try { testParse('/ 1 /') } catch (e) { println e }
