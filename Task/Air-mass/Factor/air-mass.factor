USING: formatting io kernel math math.functions math.order
math.ranges math.trig sequences ;

CONSTANT: RE 6,371,000     ! Earth's radius in meters
CONSTANT: dd 0.001         ! integrate in this fraction of the distance already covered
CONSTANT: FIN 10,000,000   ! integrate to a height of 10000km

! the density of air as a function of height above sea level
: rho ( a -- x ) neg 8500 / e^ ;

! z = zenith angle (in degrees)
! d = distance along line of sight
! a = altitude of observer
:: height ( a z d -- x )
    RE a + :> AA
    AA sq d sq + 180 z - deg>rad cos AA * d * 2 * - sqrt RE - ;

:: column-density ( a z -- x )
    ! integrates along the line of sight
    0 0 :> ( s! d! )
    [ d FIN < ] [
        dd dd d * max :> delta   ! adaptive step size to avoid taking it forever
        s a z d 0.5 delta * + height rho delta * + s!
        d delta + d!
    ] while s ;

: airmass ( a z -- x )
    [ column-density ] [ drop 0 column-density ] 2bi / ;

"Angle     0 m              13700 m" print
"------------------------------------" print
0 90 5 <range> [
    dup [ 0 swap airmass ] [ 13700 swap airmass ] bi
    "%2d %15.8f %17.8f\n" printf
] each
