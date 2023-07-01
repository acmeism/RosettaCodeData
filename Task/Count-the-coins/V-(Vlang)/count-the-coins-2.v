fn main() {
	amount := 100
	coins := [25, 10, 5, 1]
	println("amount: $amount; ways to make change: ${count(coins, amount)}")
}

fn count(coins []int, amount int) int {
	mut ways := []int{len: amount + 1}
	ways[0] = 1
	for coin in coins {
		for idx := coin; idx <= amount; idx++ {
			ways[idx] += ways[idx - coin]
		}
	}
	return ways[amount]
}
