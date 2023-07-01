const max_size = 10

struct Cache {
mut:
  values []int
}

fn fac_cached(n int, mut cache Cache) int {
  is_in_cache := cache.values.len > n
  if is_in_cache {
    return cache.values[n]
  }
  fac_n := if n == 0 { 1 } else { n * fac_cached(n - 1, mut cache) }
  cache.values << fac_n
  return fac_n
}

fn main() {
  mut cache := Cache{}
  for n := 0; n <= max_size; n++ {
    fac_n := fac_cached(n, mut cache)
    println('The $n-th Factorial is: $fac_n')
  }
}
