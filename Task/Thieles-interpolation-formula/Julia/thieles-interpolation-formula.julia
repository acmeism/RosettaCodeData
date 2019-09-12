const N = 256
const N2 = N * div(N - 1, 2)
const step = 0.01
const xval_table = zeros(Float64, N)
const tsin_table = zeros(Float64, N)
const tcos_table = zeros(Float64, N)
const ttan_table = zeros(Float64, N)
const rsin_cache = Dict{Float64, Float64}()
const rcos_cache = Dict{Float64, Float64}()
const rtan_cache = Dict{Float64, Float64}()

function rho(x, y, rhocache, i, n)
    if n < 0
        return 0.0
    elseif n == 0
        return y[i+1]
    end
    idx = (N - 1 - n) * div(N - n, 2) + i
    if !haskey(rhocache, idx)
        rhocache[idx] = (x[i+1] - x[i + n+1]) / (rho(x, y, rhocache, i, n - 1) -
            rho(x, y, rhocache, i + 1, n - 1)) + rho(x, y, rhocache, i + 1, n - 2)
    end
    rhocache[idx]
end

function thiele(x, y, r, xin, n)
    if n > N - 1
        return 1.0
    end
    rho(x, y, r, 0, n) - rho(x, y, r, 0, n - 2) + (xin - x[n + 1]) / thiele(x, y, r, xin, n + 1)
end

function thiele_tables()
    for i in 1:N
        xval_table[i] = (i-1) * step
        tsin_table[i] = sin(xval_table[i])
        tcos_table[i] = cos(xval_table[i])
        ttan_table[i] = tsin_table[i] / tcos_table[i]
    end
    println(6 * thiele(tsin_table, xval_table, rsin_cache, 0.5, 0))
    println(3 * thiele(tcos_table, xval_table, rcos_cache, 0.5, 0))
    println(4 * thiele(ttan_table, xval_table, rtan_cache, 1.0, 0))
end

thiele_tables()
