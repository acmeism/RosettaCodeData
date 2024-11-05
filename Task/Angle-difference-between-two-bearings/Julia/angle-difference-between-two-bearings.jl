using Printf

function angdiff(a, b)
    r = (b - a) % 360.0
    if r ≥ 180.0
        r -= 360.0
    end

    return r
end

println("Input in -180 to +180 range:")
for (a, b) in [(20.0, 45.0), (-45.0, 45.0), (-85.0, 90.0), (-95.0, 90.0), (-45.0, 125.0), (-45.0, 145.0),
    (-45.0, 125.0), (-45.0, 145.0), (29.4803, -88.6381), (-78.3251, -159.036)]
    @printf("% 6.1f - % 6.1f = % 6.1f\n", a, b, angdiff(a, b))
end

println("\nInput in wider range:")
for (a, b) in [(-70099.74233810938, 29840.67437876723), (-165313.6666297357, 33693.9894517456),
    (1174.8380510598456, -154146.66490124757), (60175.77306795546, 42213.07192354373)]
    @printf("% 9.1f - % 9.1f = % 6.1f\n", a, b, angdiff(a, b))
end