using SpecialFunctions

setprecision(120, base=10)

println("Apéry's constant via Julia's zeta:\n$(string(zeta(big"3"))[1:102])")

""" zeta(3) via Riemann summation of 1/(k cubed) """
Apéry_r(nterms = 1_000_000) = sum(big"1" / k^big"3" for k in 1:nterms)

println("\nApéry's constant via reciprocal cubes:\n$(string(Apéry_r())[1:102])")

""" zeta(3) via Markov's summation """
function Apéry_m(nterms = 158)
   return big"2.5" * sum((isodd(k) ? 1 : -1) * factorial(big(k))^2 /
   (factorial(big"2" * k) * k^big"3") for k in 1:nterms)
end

println("\nApéry's constant via Markov's summation:\n$(string(Apéry_m())[1:102])")

""" zeta(3) via Wedeniwski's summation """
function Apéry_w(nterms = 20)
   return big"1"/24 * sum((iseven(k) ? 1 : -1) * factorial(big"2" * k + 1)^3 *
      factorial(big"2" * k)^3 * factorial(big(k))^3 *
      (126392 * k^big"5" + 412708 * k^big"4" + 531578 * k^big"3" + 336367 * k^big"2"
         + big"104000" * k + 12463) / (factorial(big"3" * k + 2) * factorial(big"4" * k+3)^3)
         for k in 0:nterms)
end

println("\nApéry's constant via Wedeniwski's summation:\n$(string(Apéry_w())[1:102])")
