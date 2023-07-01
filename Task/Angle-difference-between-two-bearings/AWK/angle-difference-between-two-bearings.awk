# syntax: GAWK -f ANGLE_DIFFERENCE_BETWEEN_TWO_BEARINGS.AWK
BEGIN {
    fmt = "%11s %11s %11s\n"
    while (++i <= 11) { u = u "-" }
    printf(fmt,"B1","B2","DIFFERENCE")
    printf(fmt,u,u,u)
    main(20,45)
    main(-45,45)
    main(-85,90)
    main(-95,90)
    main(-45,125)
    main(-45,145)
    main(29.4803,-88.6381)
    main(-78.3251,-159.036)
    main(-70099.74233810938,29840.67437876723)
    main(-165313.6666297357,33693.9894517456)
    main(1174.8380510598456,-154146.66490124757)
    main(60175.77306795546,42213.07192354373)
    exit(0)
}
function main(b1,b2) {
    printf("%11.2f %11.2f %11.2f\n",b1,b2,angle_difference(b1,b2))
}
function angle_difference(b1,b2,  r) {
    r = (b2 - b1) % 360
    if (r < -180) {
      r += 360
    }
    if (r >= 180) {
      r -= 360
    }
    return(r)
}
