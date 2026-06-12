tobigrational(s) = (d = length(s) - something(findfirst(==('.'), s), 0); parse(BigInt, replace(s, '.' => "")) // big"10"^d)

toEngel(x) = (a = BigInt[]; while x != 0; y = ceil(big"1" // x); push!(a, y); x = x * y - 1; end; a)

fromEngel(a) = sum(accumulate((x, y) -> x // y, BigInt.(a)))

function testEngels(s)
    biginput = length(s) > 21
    r = tobigrational(s)
    println("\nNumber:           $s")
    eng = toEngel(r)
    println("Engel expansion:  ", biginput ? eng[1:min(length(s), 30)] : Int64.(eng), " ($(length(eng)) components)")
    r2 = fromEngel(eng)
    println("Back to rational: ", biginput ? BigFloat(r2) : Float64(r2))
end

setprecision(700)

foreach(testEngels, [
   "3.14159265358979",
   "2.71828182845904",
   "1.414213562373095",
   "7.59375",
   "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211",
   "2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642743",
   "1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927558",
   "25.628906",
])
