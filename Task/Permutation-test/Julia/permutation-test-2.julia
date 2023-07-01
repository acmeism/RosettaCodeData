const treated = [85, 88, 75, 66, 25, 29, 83, 39, 97]
const control = [68, 41, 10, 49, 16, 65, 32, 92, 28, 98]

(better, worse) = permutation_test(treated, control)

tot = better + worse

println("Permutation test using the following data:")
println("Treated:  ", treated)
println("Control:  ", control)
println("\nThere are $tot different permuted groups of these data.")
@printf("%8d, %5.2f%% showed better than actual results.\n", better, 100 * better / tot)
print(@sprintf("%8d, %5.2f%% showed equalivalent or worse results.", worse, 100 * worse / tot))
