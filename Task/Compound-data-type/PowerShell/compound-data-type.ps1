class Point {
  [Int]$a
  [Int]$b
  Point() {
      $this.a = 0
      $this.b = 0
  }
  Point([Int]$a, [Int]$b) {
      $this.a = $a
      $this.b = $b
  }
  [Int]add() {return $this.a + $this.b}
  [Int]mul() {return $this.a * $this.b}
}
$p1  = [Point]::new()
$p2 = [Point]::new(3,2)
$p1.add()
$p2.mul()
