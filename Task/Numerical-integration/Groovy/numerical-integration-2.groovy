double tolerance = 0.0001 // allowable "wrongness", ensures accuracy to 1 in 10,000

double sinIntegralCalculated = -(Math.cos(Math.PI) - Math.cos(0d))
assert  (leftRectIntegral([0d, Math.PI], 129, Math.&sin) - sinIntegralCalculated).abs() < tolerance
assert (rightRectIntegral([0d, Math.PI], 129, Math.&sin) - sinIntegralCalculated).abs() < tolerance
assert   (midRectIntegral([0d, Math.PI],  91, Math.&sin) - sinIntegralCalculated).abs() < tolerance
assert (trapezoidIntegral([0d, Math.PI], 129, Math.&sin) - sinIntegralCalculated).abs() < tolerance
assert  (simpsonsIntegral([0d, Math.PI],   6, Math.&sin) - sinIntegralCalculated).abs() < tolerance

double cubeIntegralCalculated = 1d/4d *(10d**4 - 0d**4)
assert  ((leftRectIntegral([0d, 10d], 20000) { it**3 } - cubeIntegralCalculated)/cubeIntegralCalculated).abs() < tolerance
assert ((rightRectIntegral([0d, 10d], 20001) { it**3 } - cubeIntegralCalculated)/cubeIntegralCalculated).abs() < tolerance
assert   ((midRectIntegral([0d, 10d],    71) { it**3 } - cubeIntegralCalculated)/cubeIntegralCalculated).abs() < tolerance
assert ((trapezoidIntegral([0d, 10d],   101) { it**3 } - cubeIntegralCalculated)/cubeIntegralCalculated).abs() < tolerance
// I can name that tune in one note!
assert  (simpsonsIntegral([0d,         10d], 1) { it**3 } == cubeIntegralCalculated)
assert  (simpsonsIntegral([0d,     Math.PI], 1) { it**3 } == (1d/4d *(Math.PI**4 - 0d**4)))
assert  (simpsonsIntegral([-7.23d, Math.PI], 1) { it**3 } == (1d/4d *(Math.PI**4 - (-7.23d)**4)))

double quarticIntegralCalculated = 1d/5d *(10d**5 - 0d**5)
assert  ((leftRectIntegral([0d, 10d], 25000) { it**4 } - quarticIntegralCalculated)/quarticIntegralCalculated).abs() < tolerance
assert ((rightRectIntegral([0d, 10d], 25001) { it**4 } - quarticIntegralCalculated)/quarticIntegralCalculated).abs() < tolerance
assert   ((midRectIntegral([0d, 10d],    92) { it**4 } - quarticIntegralCalculated)/quarticIntegralCalculated).abs() < tolerance
assert ((trapezoidIntegral([0d, 10d],   130) { it**4 } - quarticIntegralCalculated)/quarticIntegralCalculated).abs() < tolerance
assert  ((simpsonsIntegral([0d, 10d],     5) { it**4 } - quarticIntegralCalculated)/quarticIntegralCalculated).abs() < tolerance

def cubicPoly = { it**3 + 2*it**2 + 7*it + 12d }
def cubicPolyAntiDeriv = { 1/4*it**4 + 2/3*it**3 + 7/2*it**2 + 12*it }
double cubicPolyIntegralCalculated = (cubicPolyAntiDeriv(10d) - cubicPolyAntiDeriv(0d))
assert  ((leftRectIntegral([0d, 10d], 20000, cubicPoly) - cubicPolyIntegralCalculated)/cubicPolyIntegralCalculated).abs() < tolerance
assert ((rightRectIntegral([0d, 10d], 20001, cubicPoly) - cubicPolyIntegralCalculated)/cubicPolyIntegralCalculated).abs() < tolerance
assert   ((midRectIntegral([0d, 10d],    71, cubicPoly) - cubicPolyIntegralCalculated)/cubicPolyIntegralCalculated).abs() < tolerance
assert ((trapezoidIntegral([0d, 10d],   101, cubicPoly) - cubicPolyIntegralCalculated)/cubicPolyIntegralCalculated).abs() < tolerance
// I can name that tune in one note!
assert  ((simpsonsIntegral([0d, 10d],     1, cubicPoly) - cubicPolyIntegralCalculated)/cubicPolyIntegralCalculated).abs() < tolerance**2.75 // 1 in 100 billion

double cpIntegralCalc0ToPI = (cubicPolyAntiDeriv(Math.PI) - cubicPolyAntiDeriv(0d))
assert  ((simpsonsIntegral([0d, Math.PI], 1, cubicPoly) -         cpIntegralCalc0ToPI)/        cpIntegralCalc0ToPI).abs() < tolerance**2.75 // 1 in 100 billion
double cpIntegralCalcMinusEToPI = (cubicPolyAntiDeriv(Math.PI) - cubicPolyAntiDeriv(-Math.E))
assert  ((simpsonsIntegral([-Math.E, Math.PI], 1, cubicPoly) - cpIntegralCalcMinusEToPI)/ cpIntegralCalcMinusEToPI).abs() < tolerance**2.5  // 1 in 10 billion
