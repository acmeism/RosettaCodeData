foreach(println, (line for line in eachline("unixdict.txt") if occursin(r"^[^bc]*a[^c]*b.*c", line)))
