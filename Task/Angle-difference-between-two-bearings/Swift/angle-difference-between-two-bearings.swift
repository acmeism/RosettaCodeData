func angleDifference(a1: Double, a2: Double) -> Double {
  let diff = (a2 - a1).truncatingRemainder(dividingBy: 360)

  if diff < -180.0 {
    return 360.0 + diff
  } else if diff > 180.0 {
    return -360.0 + diff
  } else {
    return diff
  }
}

let testCases = [
  (20.0, 45.0),
  (-45, 45),
  (-85, 90),
  (-95, 90),
  (-45, 125),
  (-45, 145),
  (29.4803, -88.6381),
  (-78.3251, -159.036),
  (-70099.74233810938, 29840.67437876723),
  (-165313.6666297357, 33693.9894517456),
  (1174.8380510598456, -154146.66490124757),
  (60175.77306795546, 42213.07192354373)
]

print(testCases.map(angleDifference))
