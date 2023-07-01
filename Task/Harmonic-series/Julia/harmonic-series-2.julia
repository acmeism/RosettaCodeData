const harmonics = accumulate((x, y) -> x + big"1" // y, 1:12370)

println("First twenty harmonic numbers as rationals:")
foreach(i -> println(rpad(i, 3), " => ", harmonics[i]), 1:20)

println("\nThe 100th harmonic is: ", harmonics[100], "\n")

for n in 1:10
    idx = findfirst(x -> x > n, harmonics)
    print("First Harmonic > $n is at position $idx and is: ", harmonics[idx], "\n\n")
end
