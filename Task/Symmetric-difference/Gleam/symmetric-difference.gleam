import gleam/set

pub fn main() -> Nil {
  let seta = set.from_list(["John", "Bob", "Mary", "Serena"])
  let setb = set.from_list(["Jim", "Mary", "John", "Bob"])
  let _a_union_b = set.union(seta, setb)
  let _a_intersection_b = set.intersection(seta, setb)
  let symmetric_difference = set.symmetric_difference(seta, setb)
  set.to_list(symmetric_difference) |> echo
  Nil
}
