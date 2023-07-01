USING: formatting io kernel locals math math.functions math.libm
math.parser math.ranges math.trig sequences ;
IN: rosetta-code.sundial

: get-num ( str -- x ) write flush readln string>number ;

: get-input ( -- lat lng ref )
    "Enter latitude: " "Enter longitude: "
    "Enter legal meridian: " [ get-num ] tri@ ;

: .diff ( lat lng ref -- )
    - [ deg>rad sin ] dip
    "sine of latitude: %.3f\ndiff longitude: %.3f\n" printf ;

: line-angle ( lat hra-rad -- hla )
    [ deg>rad sin ] [ [ sin * ] [ cos ] bi ] bi* fatan2 rad>deg
    ;

:: .angles ( lat lng ref -- )
    "Hour, sun hour angle, dial hour line angle from 6am to 6pm"
    print
    -6 6 [a,b] [
        :> h 15.0 h * :> hra!
        ref hra lng - + hra!
        lat hra deg>rad line-angle :> hla
        h hra hla
        "HR= %3d;  \t  HRA=%7.3f;  \t  HLA= %7.3f\n" printf
    ] each ;

: sundial-demo ( -- ) get-input nl 3dup .diff nl .angles ;

MAIN: sundial-demo
