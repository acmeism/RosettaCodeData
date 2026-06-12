using Optim

const mcclow = [-1.5, -3.0]
const mccupp = [4.0, 4.0]
const miclow = [0.0, 0.0]
const micupp = Float64.([pi, pi])
const npar = [100, 1000]
const x0 = [0.0, 0.0]

michalewicz(x, m=10) = -sum(i -> sin(x[i]) * (i * sin( x[i]^2/pi))^(2*m), 1:length(x))

mccormick(x) = sin(x[1] + x[2]) + (x[1] - x[2])^2 - 1.5 * x[1] + 2.5 * x[2] + 1


println(optimize(mccormick, x0, ParticleSwarm(;lower=mcclow, upper=mccupp, n_particles=npar[1])))
@time optimize(mccormick, x0, ParticleSwarm(;lower=mcclow, upper=mccupp, n_particles=npar[1]))

println(optimize(michalewicz, x0, ParticleSwarm(;lower=miclow, upper=micupp, n_particles=npar[2])))
@time optimize(michalewicz, x0, ParticleSwarm(;lower=miclow, upper=micupp, n_particles=npar[2]))
