import rand
import os

fn main() {
	valid := ['1','2','3','4','5','6','7','8','9']
	mut value := []string{}
	mut guess, mut elem := '', ''
	mut cows, mut bulls := 0, 0
	println('Cows and Bulls')
	println('Guess four digit numbers of unique digits in the range 1 to 9.')
	println('A correct digit, but not in the correct place is a cow.')
	println('A correct digit, and in the correct place is a bull.')
	// generate pattern
	for value.len < 4 {
		elem = rand.string_from_set('123456789', 1)
		if value.any(it == elem) == false {
			value << elem
		}
	}
	// start game
	input: for _ in 0..3 {
		guess = os.input('Guess: ').str()
		// deal with malformed guesses
		if guess.len != 4 {println('Please input a four digit number.') continue input}
		for val in guess {
			if valid.contains(val.ascii_str()) == false {
				{println('Please input a number between 1 to 9.') continue input}
			}
			if guess.count(val.ascii_str()) > 1 {
				{println('Please do not repeat the same digit.') continue input}
			}
		}
		// score guesses
		for idx, gval in guess  {
			match true {
				gval.ascii_str() == value[idx] {
					bulls++
					println('${gval.ascii_str()} was correctly guessed, and in the correct location! ')

				}
				gval.ascii_str() in value {	
					cows++
					println('${gval.ascii_str()} was correctly quessed, but not in the exact location! ')
				}
				else {}
			}
			if bulls == 4 {println('You are correct and have won!!! Congratulations!!!') exit(0)}
		}
		println('score: bulls: $bulls cows: $cows')
	}
	println('Only 3 guesses allowed. The correct value was: $value')
	println('Sorry, you lost this time, try again.')
}
