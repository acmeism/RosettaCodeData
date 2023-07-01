function newton(f, fp, x::Float64,tol=1e-14::Float64,maxsteps=100::Int64)
         ##f: the function of x
         ##fp: the derivative of f

	 local xnew, xold = x, Inf
	 local fn, fo = f(xnew), Inf
	 local counter = 1

	 while (counter < maxsteps) && (abs(xnew - xold) > tol) && ( abs(fn - fo) > tol )
	   x = xnew - f(xnew)/fp(xnew) ## update x
	   xnew, xold = x, xnew
           fn, fo = f(xnew), fn
	   counter += 1
	 end

	 if counter >= maxsteps
	    error("Did not converge in ", string(maxsteps), " steps")
         else
	   xnew, counter
         end
end
