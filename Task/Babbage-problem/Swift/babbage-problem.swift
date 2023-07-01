import Swift

for i in 2...Int.max {
	if i * i % 1000000 == 269696 {
		print(i, "is the smallest number that ends with 269696")
		break
	}
}
