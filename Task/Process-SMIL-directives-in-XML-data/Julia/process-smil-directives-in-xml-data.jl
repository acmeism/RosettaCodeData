using EzXML
using Printf


""" structure for animation data """
mutable struct AnimData
	element::EzXML.Node
	attrib::String
	from::String
	to::String
	beginning::Float64
	duration::Float64
end

""" Compute interpolated value at a specific time for an animation """
function at_time(ad::AnimData, t::Float64)::String
	beg = ad.beginning
	end_time = beg + ad.duration
	if t < beg || t > end_time
		error("time must be in interval [$beg, $end_time]")
	end

	from_split = split(ad.from)
	to_split = split(ad.to)
	le = length(from_split)
	inter_split = Vector{String}(undef, le)

	for i in 1:le
		from_f = parse(Float64, from_split[i])
		to_f = parse(Float64, to_split[i])
		inter_f = (from_f * (end_time - t) + to_f * (t - beg)) / ad.duration
		inter_split[i] = @sprintf("%.2f", inter_f)
	end

	return join(inter_split, " ")
end

""" Main function to process the XML document """
function main(filename = "smil.xml")
	# parse smil XML
	doc = readxml(filename)
	root = doc.root
	smil = findfirst("//smil", root)
	if smil === nothing
		error("'smil' element not found")
	end
	x3d = findfirst("X3D", smil)
	if x3d === nothing
		error("'X3D' element not found")
	end

	# Create a new XML document with X3D as its root
	new_doc = XMLDocument()
	new_root = deepcopy(x3d)
	setroot!(new_doc, new_root)

	# Find all animate elements
	ads = AnimData[]
	for anim in findall("//animate", x3d)
        attrib, from,to, begin_val, dur_val = "","","", 0.0, 0.0
		for a in attributes(anim)
			n = a.name
			c = a.content
			if n == "attributeName"
				attrib = c
			elseif n == "from"
				from = c
			elseif n == "to"
				to = c
			elseif n == "begin"
				begin_val = parse(Float64, c[1:end-1])
			elseif n == "dur"
				dur_val = parse(Float64, c[1:end-1])
			end
		end
		parent = parentelement(anim)
		parent === nothing && error("an animate element has no parent")
		push!(ads, AnimData(parent, attrib, from, to, begin_val, dur_val))
		unlink!(anim) # empty this so that new scenes can be inserted later
	end

	for t in [0.0, 4.0, 9.0]
		for ad in ads
			s = at_time(ad, t)
			ad.element[ad.attrib] = s
		end
		@printf("At time = %g seconds:\n\n", t)
		prettyprint(new_doc)
		println()
	end
end

# Run the main function
main()
