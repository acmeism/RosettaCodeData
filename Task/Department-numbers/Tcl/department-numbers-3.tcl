set min 1
set max 7
set valid 0
for {set police $min} {$police <= $max} {incr police} {
  if {[expr $police % 2] == 1} continue ;# filter even numbers for police
  for {set sanitation $min} {$sanitation <= $max} {incr sanitation} {
    if {$police == $sanitation} continue
    for {set fire $min} {$fire <= $max} {incr fire} {
      if {$police == $fire || $sanitation == $fire} continue
      if {[expr $police + $sanitation + $fire] != 12} continue
      puts "$police $sanitation $fire"
      incr valid
    }
  }
}

puts "$valid valid combinations found."
