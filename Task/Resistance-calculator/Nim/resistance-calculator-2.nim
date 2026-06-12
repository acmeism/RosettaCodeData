proc rpn(voltage:float, s:string): Node = calculate(voltage, s.split ' ')
var node = rpn(18, "10 2 + 6 * 8 + 6 * 4 + 8 * 4 + 8 * 6 +")
assert 10 == node.res
assert 18 == node.voltage
assert 1.8 == node.current()
assert 32.4 == node.effect()
assert '+' == node.kind
