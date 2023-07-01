proc angleDiff {b1 b2} {
  set angle [::tcl::mathfunc::fmod [expr ($b2 - $b1)] 360]
  if {$angle < -180.0} {
    set angle [expr $angle + 360.0]
  }
  if {$angle >= 180.0} {
    set angle [expr $angle - 360.0]
  }
  return $angle
}

puts "Input in -180 to +180 range"
puts [angleDiff 20.0 45.0]
puts [angleDiff -45.0 45.0]
puts [angleDiff -85.0 90.0]
puts [angleDiff -95.0 90.0]
puts [angleDiff -45.0 125.0]
puts [angleDiff -45.0 145.0]
puts [angleDiff -45.0 125.0]
puts [angleDiff -45.0 145.0]
puts [angleDiff 29.4803 -88.6381]
puts [angleDiff -78.3251 -159.036]

puts "Input in wider range"
puts [angleDiff -70099.74233810938 29840.67437876723]
puts [angleDiff -165313.6666297357 33693.9894517456]
puts [angleDiff 1174.8380510598456 -154146.66490124757]
puts [angleDiff 60175.77306795546 42213.07192354373]
