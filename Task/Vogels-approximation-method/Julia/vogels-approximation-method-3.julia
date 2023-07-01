using Printf

sup = [50, 60, 50, 50]
slab = ["W", "X", "Y", "Z"]
dem = [30, 20, 70, 30, 60]
dlab = ["A", "B", "C", "D", "E"]
c = [16 16 13 22 17;
     14 14 13 19 15;
     19 19 20 23 50;
     50 12 50 15 11]

tp = TProblem(sup, dem, c, slab, dlab)
sol = vogel(tp)
cost = sum(tp.toc .* sol)

println("The solution is:")
print("        ")
for s in tp.labels[2]
    print(@sprintf "%4s" s)
end
println()
for i in 1:size(tp.toc)[1]
    print(@sprintf "    %4s" tp.labels[1][i])
    for j in 1:size(tp.toc)[2]
        print(@sprintf "%4d" sol[i,j])
    end
println()
end
println("The total cost is:  ", cost)
