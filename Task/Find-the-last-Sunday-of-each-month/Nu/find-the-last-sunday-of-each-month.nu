#!/usr/bin/nu

def last_sunday [y] {
  $'($in // 12 + $y)-($in mod 12 + 1)-01T12:00'
  | into datetime
  | $in - ($in | format date '%uday' | into duration)
}

def main [year: int] {
  for mon in 1..12 {
    $mon | last_sunday $year | format date '%F' | print
  }
}
