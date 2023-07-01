function iterate_phi(limit::T) where T <: Real
    phi, oldphi, iters = one(limit), one(limit), 0
    while true
        phi = 1 + 1 / oldphi
        iters += 1
        abs(phi - oldphi) <= limit && break
        oldphi = phi
    end
    println("Final value of phi : $phi")
    println("Number of iterations : $iters")
    println("Error (approx) : $(phi - (1 + sqrt(T(5))) / 2)")
end

iterate_phi(1 / 10^5)
iterate_phi(1 / big(10)^25)
