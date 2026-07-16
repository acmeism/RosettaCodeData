using GLMakie

"""
	The parametric equations for the Klein bottle (u, v) -> (x, y, z)
	See also https://en.wikipedia.org/wiki/Klein_bottle#Parametrization
"""
function klein_bottle_xyz(u, v)
	if u < π
		x = 6*cos(u)*(1 + sin(u)) + 4*(1 - cos(u)/2)*cos(u)*cos(v)
		y = 16*sin(u) + 4*(1 - cos(u)/2)*sin(u)*cos(v)
	else
		x = 6*cos(u)*(1 + sin(u)) + 4*(1 - cos(u)/2)*cos(v + π)
		y = 16*sin(u)
	end
	z = 4*(1 - cos(u)/2)*sin(v)
	return x, z, y # rotate the Klein bottle so that the bow is in the x-y plane
end


""" Plot the Klein bottle, a 4D surface, as 3D on a 2D pane :) using parametric equations. """
function plotkleinbottle()
	# Resolution of u, v parameters.
    # Higher values give smoother surface but take longer.
	nu = 300
	nv = 100

	u = range(0, 2π, length = nu)
	v = range(0, 2π, length = nv)

	X = Matrix{Float32}(undef, nu, nv)
	Y = similar(X)
	Z = similar(X)

	for i in eachindex(u), j in eachindex(v)
		x, y, z = klein_bottle_xyz(u[i], v[j])
		X[i, j] = x
		Y[i, j] = y
		Z[i, j] = z
	end

	fig = Figure(size = (900, 700))
	ax = Axis3(
		fig[1, 1],
		aspect = :data,
		perspectiveness = 0.7,
		azimuth = 0.5π,   # side-on view, showing the bow in profile
		elevation = 0.08π,
	)

	# Add the surface of the Klein bottle with shading
	surface!(
		ax,
		X, Y, Z;
		colormap = :plasma,
		shading = FastShading,
	)

	# outline the shape with a wireframe
	wireframe!(
		ax,
		X, Y, Z;
		color = (:white, 0.12),
		linewidth = 0.3,
	)

	display(fig)
end

plotkleinbottle()
