import rand
import os
import time

const optimum = {
	"HHH": "THH", "HHT": "THH", "HTH": "HHT", "HTT": "HHT",
	"THH": "TTH", "THT": "TTH", "TTH": "HTT", "TTT": "HTT"
}

fn main() {
	r := rand.intn(2) or {exit(1)}
	mut user_seq :=''
	mut comp_seq :=''
	mut coin :=''
	mut coins :=''
	mut len := 0
	mut seq :=''

	if r == 0 {
		println("You go first")
		user_seq = user_sequence()
		println('\n')
		comp_seq = computer_sequence(user_seq)
	}
	else {
		println("Computer goes first")
		comp_seq = computer_sequence(user_seq)
		println('\n')
		user_seq = user_sequence()
	}
	println('\n')
	for true {
		if (rand.intn(2) or {exit(1)}) == 0 {coin = 'H'} else {coin = 'T'}
		coins += coin
		println("Coins flipped: $coins")
		len = coins.len
		if len >= 3 {
			seq = coins.substr(len - 3, len)
			if seq == user_seq {
				println("\nYou win!")
				exit(0)
			}
			if seq == comp_seq {
				println("\nComputer wins!")
				exit(0)
			}
		}
		time.sleep(1 * time.second) // extraneous
	}
}

fn user_sequence() string {
	mut user_seq :=''
	println("A sequence of three H or T should be entered")
	for (user_seq.len != 3) || (user_seq.to_upper().split('').any(it != 'H' && it != 'T') == true) {
		user_seq = os.input('Enter your sequence: ').str().to_upper()
	}
	return user_seq
}

fn computer_sequence(user_seq string) string {
	mut char_array := []string{len:3}
	mut comp_seq :=''
	if user_seq == '' {
		for _ in 0..2 {
			if (rand.intn(2) or {exit(1)}) == 0 {char_array << 'T'} else {char_array << 'H'}
			comp_seq = char_array.join('')
		}
	}	
	else {
		comp_seq = optimum[user_seq]
	}
	println("Computer's sequence: $comp_seq")
	return comp_seq
}
