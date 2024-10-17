using Plots
gr(aspect_ratio=:equal, axis=true, ticks=true, legend=false, dpi=200)

d, h = 200, 1200  # pixel density (= image width) and image height
n, r = 8000, 10000  # number of iterations and escape radius (r > 2)

a = -.743643887037158704752191506114774  # https://mathr.co.uk/web/m-location-analysis.html
b = 0.131825904205311970493132056385139  # try: a, b, n = -1.748764520194788535, 3e-13, 800

x = range(0, 2, length=d+1)
y = range(0, 2 * h / d, length=h+1)

A, B = collect(x) .* pi, collect(y) .* pi
C = 8.0 .* exp.((A' .+ B .* im) .* im) .+ (a + b * im)

Z, dZ = zero(C), zero(C)
D = zeros(size(C))

for k in 1:n
    M = abs2.(Z) .< abs2(r)
    Z[M], dZ[M] = Z[M] .^ 2 .+ C[M], 2 .* Z[M] .* dZ[M] .+ 1
end

N = abs.(Z) .> 2  # exterior distance estimation
D[N] = log.(abs.(Z[N])) .* abs.(Z[N]) ./ abs.(dZ[N])

heatmap(D' .^ 0.05, c=:nipy_spectral)
savefig("Mercator_Mandelbrot_map.png")

X, Y = real(C), imag(C)  # zoom images (adjust circle size 50 and zoom level 20 as needed)
R, c, z = 50 * (2 / d) * pi .* exp.(.- B), min(d, h) + 1, max(0, h - d) ÷ 20

gr(c=:nipy_spectral, axis=true, ticks=true, legend=false, markerstrokewidth=0)
p1 = scatter(X[1z+1:1z+c,1:d], Y[1z+1:1z+c,1:d], markersize=R[1:c].^.5, marker_z=D[1z+1:1z+c,1:d].^.5)
p2 = scatter(X[2z+1:2z+c,1:d], Y[2z+1:2z+c,1:d], markersize=R[1:c].^.5, marker_z=D[2z+1:2z+c,1:d].^.4)
p3 = scatter(X[3z+1:3z+c,1:d], Y[3z+1:3z+c,1:d], markersize=R[1:c].^.5, marker_z=D[3z+1:3z+c,1:d].^.3)
p4 = scatter(X[4z+1:4z+c,1:d], Y[4z+1:4z+c,1:d], markersize=R[1:c].^.5, marker_z=D[4z+1:4z+c,1:d].^.2)
plot(p1, p2, p3, p4, layout=(2, 2))
savefig("Mercator_Mandelbrot_zoom.png")
