iround(x) = round(Int64, x)

triangle(n) = iround.(exp(diagm(-1=> 1:n)))

function pascal(n)
   t=triangle(n)
   println.(join.([filter(!iszero, t[i,:]) for i in 1:(n+1)], " "))
end
