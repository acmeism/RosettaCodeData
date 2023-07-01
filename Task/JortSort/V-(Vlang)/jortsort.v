fn main() {
  println(jort_sort([1, 2, 1, 11, 213, 2, 4])) //false
  println(jort_sort([0, 1, 0, 0, 0, 0]))       //false
  println(jort_sort([1, 2, 4, 11, 22, 22]))    //true
  println(jort_sort([0, 0, 0, 1, 2, 2]))       //true
}

fn jort_sort(a []int) bool {
  mut c := a.clone()
  c.sort()
  for k, v in c {
    if v == a[k] {
      continue
    } else {
      return false
    }
  }
  return true
}
