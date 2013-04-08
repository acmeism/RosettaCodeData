package main

import (
	. "fmt"
	"rand"
	"time"
	"os"
	"bufio"
	"strconv"
	"strings"
)

func generateTarget() int {
	rand.Seed(time.Nanoseconds())
	// loop until we find a number that doesn't have dupes
	for {
		target := rand.Intn(9000) + 1000
		if !hasDupes(target) {
			return target
		}
	}
	panic("Crap.")
}

func hasDupes(num int) bool {
	digs := make([]bool, 10)
	for num > 0 {
		if digs[num%10] {
			return true
		}
		digs[num%10] = true
		num /= 10
	}
	return false
}

func askForNumber() (int, os.Error) {
	in := bufio.NewReader(os.Stdin)

	for {
		Print("Give me a number: ")
		line, err := in.ReadString('\n')

		if err != nil {
			return -1, err
		}

		// Strip off the \n
		line = line[0 : len(line)-1]
		number, err := strconv.Atoi(line)

		switch {
		case err != nil:
			Println("Give me a number fule!")
		case number < 1000:
			Println("Number not long enough")
		case number > 9999:
			Println("Number is to big")
		case hasDupes(number):
			Println("I said no dupes!")
		default:
			return number, nil
		}
		// Keep Asking
	}
	panic("Crap.")
}

func bullsAndCows(number int, guess int) (bulls int, cows int) {
	bulls, cows = 0, 0
	numberstr := strconv.Itoa(number)
	guessstr := strconv.Itoa(guess)

	for i := range guessstr {
		s := string(guessstr[i])
		switch {
		case guessstr[i] == numberstr[i]:
			bulls++
		case strings.Index(numberstr, s) >= 0:
			cows++
		}
	}
	return;
}

func main() {
	attempts := 0

	Print("I choose a number made of 4 digits (from 1 to 9) without repetitions\n"
		"You enter a number of 4 digits, and I say you how many of them are\n"
		"in my secret number but in wrong position (cows or O), and how many\n"
		"are in the right position (bulls or X)\n\n")

	target := generateTarget()

	for {
		guess, err := askForNumber()
		attempts++

		// Handle err
		if err != nil && err != os.EOF {
			Print(err)
		} else if err == os.EOF {
			return
		}

		// Check if target matches guess
		if guess == target {
			Printf("Congratulations you guessed correctly in %d attempts\n", attempts)
			return
		}

		bulls, cows := bullsAndCows(target, guess)
		Printf("%d Bulls, %d Cows\n", bulls, cows)
	}

}
