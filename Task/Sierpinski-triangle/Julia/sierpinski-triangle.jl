function sierpinski(n, token::AbstractString="*")
	x = fill(token, 1, 1)
	for _ in 1:n
		h, w = size(x)
		s = fill(" ", h,(w + 1) ÷ 2)
		t = fill(" ", h,1)
		x = [[s x s] ; [x t x]]
	end
	return x
end

function printsierpinski(m::Matrix)
    for r in 1:size(m, 1)
        println(join(m[r, :]))
    end
end

sierpinski(4) |> printsierpinski
