using Printf

function tanh_sinh(fp, lower, upper, steps, acc)
    h = 0.1
    h0 = (upper - lower) / 2.0
    h1 = (lower + upper) / 2.0
    rr = 0.0
    for k in 1:steps
        ro = rr
        n = (1 << k) - 1
        ss = 0.0
        for i in -n:n
            t = i * h
            sh = sinh(t)
            ch = cosh(t)
            th = tanh(sh * π / 2.0)
            dx = (ch * π / 2.0) / (cosh(sh * π / 2.0))^2
            xi = h1 + h0 * th
            wt = h * dx
            ss += fp(xi) * wt
        end
        rr = h0 * ss
        if abs(rr - ro) < acc
            break
        end
    end
    return rr
end

# Test program
res = tanh_sinh(sin, 0.0, 1.0, 5, 1e-8)
@printf("%.8f\n", res)
res = tanh_sinh(exp, -3.0, 3.0, 5, 1e-8)
@printf("%.8f\n", res)
