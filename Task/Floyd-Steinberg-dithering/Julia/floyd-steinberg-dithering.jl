""" rosettacode.org/wiki/Floyd-Steinberg_dithering, see also code at github.com/JuliaImages/DitherPunk.jl """

using Images

const FLOYD_STEINBERG_MASK = [0 0 7; 3 5 1]
const FLOYD_STEINBERG_ORIGIN_COLUMN = 2

# Images.jl translates 24-bit color into an array of 3-tuples of floating point numbers in [0,1].
const RGB_8_COLORS = [
	RGB(0, 0, 0),       # Black
	RGB(1, 1, 1),       # White
	RGB(1, 0, 0),       # Red
	RGB(0, 1, 0),       # Green
	RGB(0, 0, 1),       # Blue
	RGB(1, 1, 0),       # Yellow
	RGB(1, 0, 1),       # Magenta
	RGB(0, 1, 1),       # Cyan
]

""" Metric to compare two RGB values by summing absolute differences of their components """
diffRGB(p::RGB, r::RGB) = abs(p.r - r.r) + abs(p.g - r.g) + abs(p.b - r.b)

""" Clamp the components of the RGB's floating point numbers to the range [0, 1] """
clampRGB(px::RGB) = RGB(clamp01(px.r), clamp01(px.g), clamp01(px.b))

""" Find the closest color from a set of reference colors using a given metric """
function closestcolor(px::RGB, referencecolors, metric)
	_, idx = findmin(metric(px, c) for c in referencecolors)
	return referencecolors[idx]
end

""" Perform Floyd-Steinberg dithering on an image """
function colordither(img::AbstractArray{<:Colorant};
	errordiffusionmask = FLOYD_STEINBERG_MASK,
	origincol = FLOYD_STEINBERG_ORIGIN_COLUMN,
	metric = diffRGB,
	errorclamp = clampRGB,
)
	img = convert.(floattype(eltype(img)), img) # copy as floating point matrix
	result = copy(img)
	nonzeros = findall(!iszero, errordiffusionmask)
	indices = nonzeros .- CartesianIndex(1, origincol)
	maskvalues = Float32.(errordiffusionmask[nonzeros] ./ sum(errordiffusionmask))
	for ci in CartesianIndices(img)
		px = errorclamp(img[ci])
		result[ci] = closestcolor(px, RGB_8_COLORS, metric)
		err = px - result[ci]
		for i in eachindex(indices)
			neighboridx = ci + indices[i]
			checkbounds(Bool, img, neighboridx) || continue
			img[neighboridx] += err * maskvalues[i]
		end
	end
	return clamp01nan.(result) # ensure values are in [0,1] and not NaN
end

# Test with the frog image from rosettacode.org/wiki/Color_quantization
const png = load("Quantum_frog.png")
const dithered = colordither(png)
save("dithered.png", dithered)
