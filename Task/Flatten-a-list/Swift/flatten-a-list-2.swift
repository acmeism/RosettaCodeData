func list(s: Any...) -> [Any] {
  return s
}

func flatten<T>(s: [Any]) -> [T] {
  return s.flatMap {
    switch $0 {
    case let a as [Any]:
      return flatten(a)
    case let x as T:
      return [x]
    default:
      assert(false, "value of wrong type")
    }
  }
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
