import gleam/set

pub fn main() {
  let s = set.new()
  let sa = set.insert(s, "a")
  let sab = set.from_list(["a", "b"])
  echo set.contains(sa, "a")
  let union = set.union(sa, sab)
  let union_list = set.to_list(union)
  echo union_list
  let intersection = set.intersection(sa, sab)
  let intersection_list = set.to_list(intersection)
  echo intersection_list
  let subtract = set.difference(sab, sa)
  let subtract_list = set.to_list(subtract)
  echo subtract_list
  let is_subset = set.is_subset(sa, sab)
  echo is_subset
  echo sa == sab
}
