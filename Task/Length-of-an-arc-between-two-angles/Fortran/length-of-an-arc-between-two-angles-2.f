#define DEG 0.017453292519943295769236907684886127134

function arclength( r as double, a1 as double, a2 as double ) as double
    return (360 - abs(a2 - a1)) * DEG * r
end function

print arclength(10, 10, 120)
