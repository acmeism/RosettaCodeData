using Plots

const N_INITIAL = 800 # the initial radius of the lattice Z^2. The final size will be >= (2*N+1)x(2*N+1)
const DX = [1, 0, -1, 0] # for a given (x,y) in Z^2, (x + dx, y + dy) for all (dx,dy) covers the neighborhood of (x,y)
const DY = [0, 1, 0, -1]

""" Return a copy of `A` padded with a surround of `extralayer` rows and columns of zeros. """
function addsurround(A::AbstractMatrix, extralayer::Integer)
	extralayer ≤ 0 && return copy(A)
	B = zeros(eltype(A),
		size(A, 1) + 2 * extralayer,
		size(A, 2) + 2 * extralayer)
	B[(extralayer+1):(end-extralayer),
		(extralayer+1):(end-extralayer)] .= A
	return B
end

""" Grow the simulation state by padding every tracked matrix and shifting queued indices. """
function grow!(Zlat, inqueue, odometer, queue, i1, i2, j1, j2, extralayer::Integer)
	Zlat = addsurround(Zlat, extralayer)
	inqueue = addsurround(inqueue, extralayer)
	odometer = addsurround(odometer, extralayer)
	for idx in eachindex(queue)
		x, y = queue[idx]
		queue[idx] = (x + extralayer, y + extralayer)
	end
	return Zlat, inqueue, odometer, queue,
	i1 + extralayer, i2 + extralayer, j1 + extralayer, j2 + extralayer
end

"""
	Moves the pile's sand grains of size N stacked all at the origin of Z^2 until the
	sandpile settles to its stable configuration. Returns the final lattice Zlat, an
	odometer matrix of how many topples occurred at each site, and a heatmap plot plt.
"""
function abelian_sandsettle(N::Integer, verbose::Bool = false)
	N < 0 && throw(ArgumentError("N must be nonnegative"))
	side = 2 * N_INITIAL + 1
	center = N_INITIAL + 1
	Zlat = zeros(Int, side, side)
	inqueue = falses(side, side)
	odometer = zeros(UInt64, side, side)
	queue = Tuple{Int, Int}[]
	i1 = i2 = j1 = j2 = center
	elapsed = @elapsed begin
		Zlat[center, center] = N
		push!(queue, (center, center))
		inqueue[center, center] = true

		while !isempty(queue)
			x, y = pop!(queue)
			inqueue[x, y] = false

			grains = Zlat[x, y]
			grains < 4 && continue

			topples = grains ÷ 4
			Zlat[x, y] = grains - 4 * topples
			odometer[x, y] += UInt64(4 * topples)

			if x == 1 || x == size(Zlat, 1) || y == 1 || y == size(Zlat, 2)
				growth = max(16, cld(max(size(Zlat, 1), size(Zlat, 2)), 8))
				Zlat, inqueue, odometer, queue, i1, i2, j1, j2 =
					grow!(Zlat, inqueue, odometer, queue, i1, i2, j1, j2, growth)
				x += growth
				y += growth
			end

			@inbounds for k in eachindex(DX)
				nx = x + DX[k]
				ny = y + DY[k]
				Zlat[nx, ny] += topples

				if Zlat[nx, ny] ≥ 4 && !inqueue[nx, ny]
					push!(queue, (nx, ny))
					inqueue[nx, ny] = true
				end
			end

			i1 = min(i1, x - 1)
			i2 = max(i2, x + 1)
			j1 = min(j1, y - 1)
			j2 = max(j2, y + 1)
		end
	end

	verbose && println("Final lattice size: $(i2 - i1 + 1)x$(j2 - j1 + 1)")
	verbose && println("Elapsed time: $(round(elapsed; digits=3)) s")
	plt = heatmap(Zlat,
		title = "Final Abelian Sandpile Lattice (N = $N)",
		xlims = (i1, i2),
		ylims = (j1, j2),
		axis = nothing,
		aspect_ratio = :equal,
		c = cgrad(:roma))
	return Zlat, odometer, plt
end


Zlat, odometer, plt = abelian_sandsettle(128_000)
display(plt)
if !isinteractive()
	println("Press Enter to exit...")
    readline()
end
