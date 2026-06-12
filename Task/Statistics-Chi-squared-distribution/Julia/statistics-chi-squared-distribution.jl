""" Rosetta Code task rosettacode.org/wiki/Statistics/Chi-squared_distribution """


""" gamma function to 12 decimal places """
function gamma(x)
    p = [ 0.99999999999980993, 676.5203681218851, -1259.1392167224028,
          771.32342877765313, -176.61502916214059, 12.507343278686905,
          -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7 ]
    if x < 0.5
        return π / (sinpi(x) * gamma(1.0 - x))
    else
        x -= 1.0
        t = p[1]
        for i in 1:8
            t += p[i+1] / (x + i)
        end
    end
    w = x + 7.5
    return sqrt(2.0 * π) * w^(x+0.5) * exp(-w) * t
end

""" Chi-squared function, the probability distribution function (pdf) for chi-squared """
function χ2(x, k)
    return x > 0 ? x^(k/2 - 1) * exp(-x/2) / (2^(k/2) * gamma(k / 2)) : 0
end

""" lower incomplete gamma by series formula with gamma """
function gamma_cdf(k, x)
    return x^k * exp(-x) * sum(x^m / gamma(k + m + 1) for m in 0:100)
end

""" Cumulative probability function (cdf) for chi-squared """
function cdf_χ2(x, k)
    return x <= 0 || k <= 0 ? 0.0 : gamma_cdf(k / 2, x / 2)
end

println("x           χ2 k = 1             k = 2             k = 3             k = 4             k = 5")
println("-"^93)
for x in 0:10
      print(lpad(x, 2))
      for k in 1:5
        s = string(χ2(x, k))
        print(lpad(s[1:min(end, 13)], 18), k % 5 == 0 ? "\n" : "")
      end
end

println("\nχ2 x     cdf for χ2   P value (df=3)\n", "-"^36)
for p in [1, 2, 4, 8, 16, 32]
    cdf = round(cdf_χ2(p, 3), digits=10)
    println(lpad(p, 2), "     ", cdf, "   ",  round(1.0 - cdf, digits=10))
end

airportdata = [ 77 23 ;
                88 12;
                79 21;
                81 19 ]

expected_data = [ 81.25 18.75 ;
                  81.25 18.75 ;
                  81.25 18.75 ;
                  81.25 18.75 ; ]

dtotal = sum((airportdata[i] - expected_data[i])^2/ expected_data[i] for i in 1:length(airportdata))

println("\nFor the airport data, diff total is $dtotal, χ2 is ", χ2(dtotal, 3), ", p value ", cdf_χ2(dtotal, 3))

using Plots
x = 0.0:0.01:10
y = [map(p -> χ2(p, k), x) for k in 0:3]

plot(x, y, yaxis=[-0.1, 0.5], labels=[0 1 2 3])
