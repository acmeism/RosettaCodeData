fn main() {
    amount := 100
    println("amount: $amount; ways to make change: ${count_change(amount)}")
}

fn count_change(amount int) i64 {
	if amount.str().count('0') > 4 {exit(-1)} // can be too slow
    return cc(amount, 4)
}

fn cc(amount int, kinds_of_coins int) i64 {
    if amount == 0 {return 1}
    else if amount < 0 || kinds_of_coins == 0 {return 0}
    return cc(amount, kinds_of_coins-1) +
        cc(amount - first_denomination(kinds_of_coins), kinds_of_coins)
}

fn first_denomination(kinds_of_coins int) int {
    match kinds_of_coins {
		1 {return 1}
		2 {return 5}
		3 {return 10}
		4 {return 25}
		else {exit(-2)}
	}
	return kinds_of_coins
}
