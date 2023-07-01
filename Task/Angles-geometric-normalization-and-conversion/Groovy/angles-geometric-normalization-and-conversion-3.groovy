Number.metaClass.mixin AngleCategory

[ -2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000 ].each { rawAngle ->
    println "\n raw angle      normalized       ------------------------------   conversions   ------------------------------"
    [rawAngle.deg, rawAngle.grad, rawAngle.mil, rawAngle.rad].each { angle ->
        printf("%10s %20s %s %s %s %s\n", rawAngle.toString(), angle,
            angle as Degrees, angle as Gradians,
            angle as Mils, angle as Radians
        )
    }
}

// some additional checks implied in the task statement
// but not requested for solution demonstration
assert 360.deg == 0.deg
assert 90.deg == 100.grad
assert Math.PI.rad == 3200.mil
