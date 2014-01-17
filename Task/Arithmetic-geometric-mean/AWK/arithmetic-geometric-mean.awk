#!/usr/bin/awk -f
BEGIN {
	printf "%.16g\n", agm(1.0,sqrt(0.5))
}
function agm(a,g) {
	while (1) {
		a0=a
		a=(a0+g)/2
		g=sqrt(a0*g)
		if (abs(a0-a) < abs(a)*1e-15) break
	}
	return a
}
function abs(x) {
	return (x<0 ? -x : x)
}
