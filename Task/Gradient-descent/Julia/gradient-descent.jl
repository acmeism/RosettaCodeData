using Optim, Base.MathConstants

f(x) = (x[1] - 1) * (x[1] - 1) * e^(-x[2]^2) + x[2] * (x[2] + 2) * e^(-2 * x[1]^2)

println(optimize(f, [0.1, -1.0], GradientDescent()))
