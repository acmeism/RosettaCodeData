import strutils, strformat

type
  Node = ref object
    kind: char  #  + = serial  * = parallel  r = resistor
    resistance: float
    voltage: float
    a: Node
    b: Node

proc res(node: Node): float =
  if node.kind == '+': return node.a.res + node.b.res
  if node.kind == '*': return 1 / (1 / node.a.res + 1 / node.b.res)
  node.resistance

proc current(node: Node): float = node.voltage / node.res
proc effect (node: Node): float = node.current * node.voltage

proc report(node: Node, level: string = "") =
  echo fmt"{node.res:8.3f} {node.voltage:8.3f} {node.current:8.3f} {node.effect:8.3f}  {level}{node.kind}"
  if node.kind in "+*":
    node.a.report level & "| "
    node.b.report level & "| "

proc setVoltage(node: Node, voltage: float) =
  node.voltage = voltage
  if node.kind == '+':
    let ra = node.a.res
    let rb = node.b.res
    node.a.setVoltage ra / (ra+rb) * voltage
    node.b.setVoltage rb / (ra+rb) * voltage
  if node.kind == '*':
    node.a.setVoltage voltage
    node.b.setVoltage voltage

proc build(tokens: seq[string]): Node =
  var stack: seq[Node]
  for token in tokens:
    stack.add if token == "+": Node(kind: '+', a: stack.pop, b: stack.pop)
              elif token == "*": Node(kind: '*', a: stack.pop, b: stack.pop)
              else: Node(kind: 'r', resistance: parseFloat(token))
  stack.pop

proc calculate(voltage: float, tokens: seq[string]): Node =
  echo ""
  echo "     Ohm     Volt   Ampere     Watt  Network tree"
  let node = build tokens
  node.setVoltage voltage
  node.report
  node
