set valid 0
for {set police 2} {$police <= 6} {incr police 2} {
  for {set sanitation 1} {$sanitation <= 7} {incr sanitation} {
    if {$police == $sanitation} continue
    for {set fire 1} {$fire <= 7} {incr fire} {
      if {$police == $fire || $sanitation == $fire} continue
      if {[expr $police + $sanitation + $fire] != 12} continue
      puts "$police $sanitation $fire"
      incr valid
    }
  }
}
puts "$valid valid combinations found."
