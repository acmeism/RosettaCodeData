using Printf
using Primes


""" Find and count multiplicatively perfect integers up to thresholds """
function testmultiplicativelyperfects(thresholds = [500, 5000, 50_000, 500_000])
    mpcount, scount = 0, 0
    pmask = primesmask(thresholds[end])
    println("Multiplicatively perfect numbers under $(thresholds[begin]):")
    for n in 1:thresholds[end]
        f = factor(n).pe
        flen = length(f)
        if flen == 2 && f[1][2] == 1 == f[2][2] || flen == 1 && f[1][2] == 3
            mpcount += 1
            if n < thresholds[begin]
                @printf("%3d * %3d = %3d   ", f[1][1], n ÷ f[1][1], n)
                mpcount % 5 == 0 && println()
            end
        end
        if n in thresholds
            cbsum, sqsum = sum(pmask[1:Int(floor(n^(1/3)))]), sum(pmask[1:isqrt(n)])
            scount = mpcount - cbsum + sqsum
            @printf("\nCounts under %d: MPNs = %7d  Semi-primes = %7d\n", n, mpcount, scount)
        end
    end
end

testmultiplicativelyperfects()
