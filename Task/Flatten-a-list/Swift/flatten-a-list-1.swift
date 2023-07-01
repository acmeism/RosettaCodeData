func list(s: Any...) -> [Any] {
  return s
}

func flatten<T>(s: [Any]) -> [T] {
  var r = [T]()
  for e in s {
    switch e {
    case let a as [Any]:
      r += flatten(a)
    case let x as T:
      r.append(x)
    default:
      assert(false, "value of wrong type")
    }
  }
  return r
}

let s = list(list(1),
  2,
  list(list(3, 4), 5),
  list(list(list())),
  list(list(list(6))),
  7,
  8,
  list()
)
println(s)
let result : [Int] = flatten(s)
println(result)
