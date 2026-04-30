pub fn all_equal(strs: List(String)) -> Bool {
  all_fulfill(fn(s1, s2) { s1 == s2 }, strs)
}

pub fn all_increasing(strs: List(String)) -> Bool {
  all_fulfill(fn(s1, s2) { string.compare(s1, s2) == order.Lt }, strs)
}

fn all_fulfill(check: fn(String, String) -> Bool, strings: List(String)) -> Bool {
  let pairs = list.zip(strings, list.drop(strings, 1))
  list.all(pairs, fn(pair) { check(pair.0, pair.1) })
}
