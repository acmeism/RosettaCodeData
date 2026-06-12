# syntax: GAWK -f AIR_MASS.AWK
# converted from FreeBASIC
BEGIN {
    dd = 0.001  # integrate in this fraction of the distance already covered
    DEG = 0.017453292519943295769236907684886127134 # degrees to radians
    RE = 6371000 # Earth radius in meters
    print("Angle          0 m      13700 m")
    for (z=0; z<=90; z+=5) {
      printf("%5d %12.8f %12.8f\n",z,am_airmass(0,z),am_airmass(13700,z))
    }
    exit(0)
}
function am_airmass(a,z) {
    return am_column_density(a,z) / am_column_density(a,0)
}
function am_column_density(a,z,  d,delta,sum) { # integrates density along the line of sight
    while (d < 10000000) { # integrate only to a height of 10000km, effectively infinity
      delta = max(dd,(dd)*d) # adaptive step size to avoid it taking forever
      sum += am_rho(am_height(a,z,d+0.5*delta))*delta
      d += delta
    }
    return(sum)
}
function am_height(a,z,d,  aa,hh) {
# a - altitude of observer
# z - zenith angle in degrees
# d - distance along line of sight
    aa = RE + a
    hh = sqrt(aa^2 + d^2 - 2*d*aa*cos((180-z)*DEG))
    return(hh-RE)
}
function am_rho(a) { # density of air as a function of height above sea level
    return exp(-a/8500.0)
}
function max(x,y) { return((x > y) ? x : y) }
