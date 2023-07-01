leonardo_numbers <- function(add = 1, l0 = 1, l1 = 1, how_many = 25) {
	result <- c(l0, l1)
	for (i in 3:how_many)
		result <- append(result, result[[i - 1]] + result[[i - 2]] + add)
	result
}
cat("First 25 Leonardo numbers\n")
cat(leonardo_numbers(), "\n")

cat("First 25 Leonardo numbers from 0, 1 with add number = 0\n")
cat(leonardo_numbers(0, 0, 1), "\n")
