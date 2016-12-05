import Darwin
func compose<A,B,C>(f: (B) -> C, g: (A) -> B) -> (A) -> C {
  return { f(g($0)) }
}
let funclist = [ { (x: Double) in sin(x) }, { (x: Double) in cos(x) }, { (x: Double) in pow(x, 3) } ]
let funclisti = [ { (x: Double) in asin(x) }, { (x: Double) in acos(x) }, { (x: Double) in cbrt(x) } ]
println(map(zip(funclist, funclisti)) { f, inversef in compose(f, inversef)(0.5) })
