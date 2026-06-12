import math

fn main() {
    mut nir, mut pir := 0, 1
    for nir < 22 {
      print("$nir  ")
        pir++
        if is_prime(pir) { nir++ }
    }
}

fn is_prime(nir int) bool {
    if nir <= 1 { return false }
    if nir == 2 { return true }
    limit := int(math.sqrt(f64(nir)))
    for ir := 2; ir <= limit; ir++ {
        if nir % ir == 0 { return false }
    }
    return true
}
