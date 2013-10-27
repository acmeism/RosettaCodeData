# syntax: GAWK -f HORIZONTAL_SUNDIAL_CALCULATIONS.AWK
BEGIN {
    printf("enter latitude (degrees): ") ; getline latitude
    printf("enter longitude (degrees): ") ; getline longitude
    printf("enter legal meridian (degrees): ") ; getline meridian
    printf("\nhour  sun hour angle  dial hour line angle\n")
    slat = sin(dr(latitude))
    for (hour=-6; hour<=6; hour++) { # 6AM-6PM
      hra = 15 * hour - longitude + meridian
      hraRad = dr(hra)
      hla = rd(atan2(sin(hraRad)*slat,cos(hraRad)))
      printf("%4d %15.3f %21.3f\n",hour+12,hra,hla)
    }
    exit(0)
}
function dr(x) { return x * 3.14159265 / 180 } # degrees to radians
function rd(x) { return x * 180 / 3.14159265 } # radians to degrees
