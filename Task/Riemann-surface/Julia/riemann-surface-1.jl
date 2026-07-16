using GLMakie

""" Parameters for plotting a complex function f(z) on a Riemann surface. """
mutable struct ComplexPlottingParameters
	func::Function
	xrange::AbstractRange{Float64}
	yrange::AbstractRange{Float64}
	title::String
	xlabel::String
	ylabel::String
	zlabel::String
	colorbarlabel::String
end

# Define the multi-valued Riemann surface function f(z) = √z
f(z) = sqrt(z)

const ComplexGraphParams = ComplexPlottingParameters(
	f,
	-2:0.01:2,
	-2:0.01:2,
	"Riemann Surface for f(z) = √z",
	"Re(z)",
	"Im(z)",
	"|f(z)|",
	"arg(f(z))",
)

""" Plot a Riemann surface for a complex function f(z) using the given plotting parameters. """
function riemannplot(P::ComplexPlottingParameters)
	# Set up the plotting grid
	x = collect(P.xrange)
	y = collect(P.yrange)
	z_grid = [xi + yi*im for xi in x, yi in y]

	# Compute the function values
	w_grid = P.func.(z_grid)

	# Extract amplitude (height) and phase (color)
	amplitude = abs.(w_grid)
	phase     = angle.(w_grid)

	# Plot the Riemann surface: height = |w|, color = arg(w) via cyclic HSV map
	fig = Figure()
	ax  = Axis3(fig[1, 1], title = P.title,
	xlabel = P.xlabel, ylabel = P.ylabel, zlabel = P.zlabel)
	surface!(ax, x, y, amplitude;
		color = phase, colormap = :hsv, colorrange = (-π, π))
	Colorbar(fig[1, 2]; colormap = :hsv, colorrange = (-π, π),
		label = P.colorbarlabel)

	# Display the interactive 3D plot
	display(fig)
end


# Plot the Riemann surface with parameters for function f(z) = √z
riemannplot(ComplexGraphParams)

# Wait for user input before exiting if not in interactive mode
if !isinteractive()
	println("Press Return to exit...")
	readline()
end
