""" rosettacode.org/wiki/Pfaffian_and_hfaffian """

using BenchmarkTools
using Combinatorics
using LinearAlgebra

# Compute the Pfaffian or hfaffian of a 2n x 2n matrix
function faffian(a::Matrix; isPfaffian = true)
    n = size(a, 1) ÷ 2
    @assert all(iseven.(size(a))) "Matrix must be 2n x 2n for Pfaffian or Hfaffian."
    @assert !isPfaffian || norm(a + a') < 1e-14 * n "Pfaffian matrix must be antisymmetric."
    total = 0.0
    normalization = inv(2^n * factorial(n))
    for σ in permutations(1:2*n)
        term = isPfaffian && isodd(parity(σ)) ? -1.0 : 1.0
        for i in 1:n
            term *= a[σ[2*i-1], σ[2*i]]
        end
        total += term
    end
    return total * normalization
end
pfaffian(a) = faffian(a, isPfaffian = true)
hfaffian(a) = faffian(a, isPfaffian = false)


""" Compute the Pfaffian of skew-symmetric matrix using Parlett-Reid algorithm """
function pr_pfaffian(a::Matrix{T})::T where T <: AbstractFloat
    n, n2 = size(a)
    # Input validation
    @assert n == n2 "Argument is not a square matrix"
    @assert norm(a + a') < 1e-14 * n "Argument does not seem skew-symmetric"

    isodd(n) && return zero(T)
    faff = one(T)
    for k in 1:2:n-2
        # Find the largest entry in a[k+1:n,k] and permute it to a[k+1,k]
        _, kp = findmax(abs, a[k+1:n, k])
        kp += k
        # Check if we need to pivot
        if kp != k + 1
            # Interchange rows k+1 and kp
            a[[k + 1, kp], k:n] = a[[kp, k + 1], k:n]
            # Interchange columns k+1 and kp
            a[k:n, [k + 1, kp]] = a[k:n, [kp, k + 1]]
            faff = -faff # each interchange causes change in sign of permutation
        end
        faff *= a[k, k+1]
        # Form the Gauss vector
        if abs(a[k+1, k]) > 1e-14 # if not nearly 0
            tau = a[k+2:n, k] ./ a[k+1, k]
            # Update the matrix block a[k+2:n,k+2:n]
            a[k+2:n, k+2:n] .+= tau * a[k+2:n, k+1]' - a[k+2:n, k+1] * tau'
        end
    end

    return faff * a[n-1, n]
end

det_pfaffian(a) = sqrt(det(a))

function testxfaffians()
    test_matrices = [
        # tiny matrix
        [ 0 1
            -1 0],
        # small matrix
        [
             0  1 -1  2
            -1  0  3 -4
             1 -3  0  5
            -2  4 -5  0
        ],
        # larger matrix
        [
             0  1  2  3  4  5  6  7  8  9
            -1  0  8  7  6  5  4  3  2  1
            -2 -8  0  1  2  3  4  5  6  7
            -3 -7 -1  0  6  5  4  3  2  1
            -4 -6 -2 -6  0  1  2  3  4  5
            -5 -5 -3 -5 -1  0  4  3  2  1
            -6 -4 -4 -4 -2 -4  0  1  2  3
            -7 -3 -5 -3 -3 -3 -1  0  2  1
            -8 -2 -6 -2 -4 -2 -2 -2  0  1
            -9 -1 -7 -1 -5 -1 -3 -1 -1  0
        ],
        # Symmetric matrix for testing
        [
            1  2  3  4  5  6
            2  7  8  9 10 11
            3  8 12 13 14 15
            4  9 13 16 17 18
            5 10 14 17 19 20
            6 11 15 18 20 21
        ],
    ]
    for mat in test_matrices
        display(mat)
        # if a is antisymmetric, a = -transpose(a), so norm of their sum is approx 0
        if norm(mat + mat') < 1e-14 * size(mat, 1)
            println("Pfaffian with separate permutations time: ")
            @btime pfaffian($mat)
            println("Pfaffian: ", pfaffian(mat))
            println("\nHfaffian with separate permutations time: ")
            @btime hfaffian($mat)
            println("Hfaffian: ", hfaffian(mat))
            println("\nPfaffian with Partlett-Reid algorithm time: ")
            @btime pr_pfaffian(float.($mat))
            println("Parlett-Reid Pfaffian: ", round(pr_pfaffian(float.(mat)), sigdigits = 14))
            println("\nPfaffian with square root of determinant time: ")
            @btime det_pfaffian($mat)
            println("Square root of determinant Pfaffian: ", round(det_pfaffian(mat), sigdigits = 14), "\n")
        else
            @warn "Matrix does not seem to be antisymmetric."
        end
    end
end

testxfaffians()
