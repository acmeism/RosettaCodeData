def verifyAngle = { angles ->
    def ma = meanAngle(angles)
    printf("Mean Angle for $angles: %5.2f%n", ma)
    round(ma * 100) / 100.0
}
assert verifyAngle([350, 10]) == -0
assert verifyAngle([90, 180, 270, 360]) == -90
assert verifyAngle([10, 20, 30]) == 20
