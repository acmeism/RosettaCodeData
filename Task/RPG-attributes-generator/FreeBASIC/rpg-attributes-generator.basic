#define min(a, b) iif(a < b, a, b)

function d6() as integer
    'simulates a marked regular hexahedron coming to rest on a plane
    return 1+int(rnd*6)
end function

function roll_stat() as integer
    'rolls four dice, returns the sum of the three highest
    dim as integer a=d6(), b=d6(), c=d6(), d=d6()
    return a + b + c + d - min( min(a, b), min(c, d) )
end function

dim as string*3 statnames(1 to 6) = {"STR", "CON", "DEX", "INT", "WIS", "CHA"}
dim as integer stat(1 to 6), n15, sum
dim as boolean acceptable = false

randomize timer
do
    sum = 0
    n15 = 0
    for i as integer = 1 to 6
        stat(i) = roll_stat()
        sum = sum + stat(i)
        if stat(i)>=15 then n15 += 1
    next i
    if sum>=75 and n15 >=2 then acceptable = true
loop until acceptable

for i as integer = 1 to 6
    print using "&:  ##";statnames(i);stat(i)
next i
print "--------"
print using "TOT:  ##";sum
