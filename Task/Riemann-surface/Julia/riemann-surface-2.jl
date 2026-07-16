using GLMakie

""" Parameters for plotting a complex function f(z) on a Riemann surface. """
mutable struct ComplexPlottingParameters
	func::Function
	range1::AbstractRange{Float64}
	range2::AbstractRange{Float64}
	title::String
	xlabel::String
	ylabel::String
	zlabel::String
	colorbarlabel::String
end

# Define the multi-valued Riemann surface function f(z) = √z
f(z) = sqrt(z)

const HELIX_PARAMETERS = ComplexPlottingParameters(
	f,
	0.05:0.01:2.0,
	-2π:0.01:2π,
	"Helical Riemann Surface for f(z) = √z",
	"Re(z)",
	"Im(z)",
	"|f(z)|",
	"arg(f(z))",
)

"""
    Plot the Riemann surface of f(z) as a helical surface using polar coordinates,
    spanning two full sheets to reveal the branch structure.
"""
function helicalplot(param::ComplexPlottingParameters)
	# Polar grid: r ∈ (0, 2], θ ∈ [-2π, 2π] spans two full sheets
	r_vals = param.range1
	θ_vals = param.range2

	# Compute Cartesian domain positions and function values
	xs     = [r * cos(θ) for r in r_vals, θ in θ_vals]
	ys     = [r * sin(θ) for r in r_vals, θ in θ_vals]
	w_grid = [param.func(r * exp(im * θ)) for r in r_vals, θ in θ_vals]

	# Height encodes arg(w) as θ/2 directly (avoids the ±π wrap discontinuity)
	zs     = [θ / 2 for r in r_vals, θ in θ_vals]
	colors = abs.(w_grid)

    figure = Figure(size = (600, 400))
	ax  = Axis3(figure[1, 1],
		title  = param.title,
		xlabel = param.xlabel, ylabel = param.ylabel, zlabel = param.zlabel)
	surface!(ax, xs, ys, zs; color = colors, colormap = :viridis)
	Colorbar(figure[1, 2]; colormap = :viridis, label = param.colorbarlabel)
    display(figure)
end

# Plot the helical Riemann surface
helicalplot(HELIX_PARAMETERS)

# Wait for user input before exiting if not in interactive mode
if !isinteractive()
	println("Press Return to exit...")
	readline()
end
