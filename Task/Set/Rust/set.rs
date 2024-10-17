use std::collections::HashSet;

fn main() {
  let a = vec![1, 3, 4].into_iter().collect::<HashSet<i32>>();
  let b = vec![3, 5, 6].into_iter().collect::<HashSet<i32>>();

  println!("Set A: {:?}", a.iter().collect::<Vec<_>>());
  println!("Set B: {:?}", b.iter().collect::<Vec<_>>());
  println!("Does A contain 4? {}", a.contains(&4));
  println!("Union: {:?}", a.union(&b).collect::<Vec<_>>());
  println!("Intersection: {:?}", a.intersection(&b).collect::<Vec<_>>());
  println!("Difference: {:?}", a.difference(&b).collect::<Vec<_>>());
  println!("Is A a subset of B? {}", a.is_subset(&b));
  println!("Is A equal to B? {}", a == b);
}
