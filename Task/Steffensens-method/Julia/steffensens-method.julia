""" Aitken's extrapolation """
function aitken(f, p0)
    p1 = f(p0)
    p2 = f(p1)
    return p0 - (p1 - p0)^2 / (p2 - 2 * p1 + p0)
end

""" Steffensen's method using Aitken """
function steffensen_aitken(f, pinit, tol, maxiter)
    p0 = pinit
    p = aitken(f, p0)
    iter = 1
    while abs(p - p0) > tol && iter < maxiter
        p0 = p
        p = aitken(f, p0)
        iter += 1
    end
    return abs(p - p0) > tol ? NaN : p
end

""" deCasteljau function """
function deCasteljau(c0, c1, c2, t)
    s = 1.0 - t
    return s * (s * c0 + t * c1) + t * (s * c1 + t * c2)
end

xConvexLeftParabola(t) = deCasteljau(2, -8, 2, t)
yConvexRightParabola(t) = deCasteljau(1, 2, 3, t)
implicit_equation(x, y) = 5 * x^2 + y - 5

""" may return NaN on overflow """
function f(t)
    return t in [nothing, NaN, Inf, -Inf] ? NaN :
       implicit_equation(xConvexLeftParabola(t), yConvexRightParabola(t)) + t
end

""" test the example """
function test_steffensen(tol = 0.00000001, iters = 1000, stepsize = 0.1)
    for t0 in 0:stepsize:1.1
        print("t0 = $t0 : ")
        t = steffensen_aitken(f, t0, tol, iters)
        if isnan(t)
            println("no answer")
        else
            x = xConvexLeftParabola(t)
            y = yConvexRightParabola(t)
            if abs(implicit_equation(x, y)) <= tol
                println("intersection at ($(Float32(x)), $(Float32(y)))")
            else
                println("spurious solution")
            end
        end
    end
    return 0
end

test_steffensen()
