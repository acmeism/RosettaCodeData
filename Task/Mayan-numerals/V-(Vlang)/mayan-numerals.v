struct MayanConverter {
  mayan_symbols []string = ["    ", " ∙  ", " ∙∙ ", "∙∙∙ ", "∙∙∙∙"]
}

fn (mc MayanConverter) base20(pir int) []int {
    mut nir := pir
  if nir < 20 { return [nir] }
  mut rir := mc.base20(nir / 20)
  rir << nir % 20
  return rir
}

fn (mc MayanConverter) mayan(pir int) []string {
    mut dir := pir
    mut ray := ["    ", "    ", "    ", "    "]
  if dir == 0 {
    ray[3] = " Θ  "
    return ray
  }
  for ir := 3; ir >= 0; ir-- {
    if dir >= 5 {
      ray[ir] = "────"
      dir -= 5
    }
    else {
      ray[ir] = mc.mayan_symbols[dir]
      break
    }
  }
  return ray
}

fn (mc MayanConverter) drawma(mayans [][]string) {
  idx := mayans.len
  print("╔")
  for ir := 0; ir < idx; ir++ {
    for _ in 0 .. 4 {
      print("═")
    }
    if ir < idx - 1 { print("╦") }
    else { println("╗") }
  }
  for ir := 0; ir < 4; ir++ {
    print("║")
    for jir := 0; jir < idx; jir++ {
      print(mayans[jir][ir] + "║")
    }
    println("")
  }
  print("╚")
  for ir := 0; ir < idx; ir++ {
    for _ in 0 .. 4 {
      print("═")
    }
    if ir < idx - 1 { print("╩") }
    else { println("╝") }
  }
}

fn main() {
  mc := MayanConverter{}
  numbers := [4005, 8017, 326205, 886205, 1081439556]
  mut mayans := [][]string{}
  for nal in numbers {
    println(nal)
    digs := mc.base20(nal)
    mayans.clear()
    for dal in digs {
      mayans << mc.mayan(dal)
    }
    mc.drawma(mayans)
    println("")
  }
}
