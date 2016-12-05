class Complex {
  [Double]$x
  [Double]$y
  Complex() {
      $this.x = 0
      $this.y = 0
  }
  Complex([Double]$x, [Double]$y) {
      $this.x = $x
      $this.y = $y
  }
  [Double]abs2() {return $this.x*$this.x + $this.y*$this.y}
  [Double]abs() {return [math]::sqrt($this.abs2())}
  static [Complex]add([Complex]$m,[Complex]$n) {return [Complex]::new($m.x+$n.x, $m.y+$n.y)}
  static [Complex]mul([Complex]$m,[Complex]$n) {return [Complex]::new($m.x*$n.x - $m.y*$n.y, $m.x*$n.y + $n.x*$m.y)}
  [Complex]mul([Double]$k) {return [Complex]::new($k*$this.x, $k*$this.y)}
  [Complex]negate() {return $this.mul(-1)}
  [Complex]conjugate() {return [Complex]::new($this.x, -$this.y)}
  [Complex]inverse() {return $this.conjugate().mul(1/$this.abs2())}
  [String]show() {
    if(0 -ge $this.y) {
        return "$($this.x)+$($this.y)i"
    } else {
        return "$($this.x)$($this.y)i"
    }
  }
  static [String]show([Complex]$other) {
    return $other.show()
  }
}
$m = [complex]::new(3, 4)
$n = [complex]::new(7, 6)
"`$m: $($m.show())"
"`$n: $($n.show())"
"`$m + `$n: $([complex]::show([complex]::add($m,$n)))"
"`$m * `$n: $([complex]::show([complex]::mul($m,$n)))"
"negate `$m: $($m.negate().show())"
"1/`$m: $([complex]::show($m.inverse()))"
"conjugate `$m: $([complex]::show($m.conjugate()))"
