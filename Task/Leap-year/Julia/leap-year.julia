isleap(yr::Integer) = yr % 4 == 0 && (yr < 1582 || yr % 400 == 0 || yr % 100 != 0)

@assert all(isleap, [2400, 2012, 2000, 1600, 1500, 1400])
@assert !any(isleap, [2100, 2014, 1900, 1800, 1700, 1499])
