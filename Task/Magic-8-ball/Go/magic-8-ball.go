package main

import (
	"bufio"
	"bytes"
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixNano())
	answers := [...]string{
		"It is certain", "It is decidedly so", "Without a doubt",
		"Yes, definitely", "You may rely on it", "As I see it, yes",
		"Most likely", "Outlook good", "Signs point to yes", "Yes",
		"Reply hazy, try again", "Ask again later",
		"Better not tell you now", "Cannot predict now",
		"Concentrate and ask again", "Don't bet on it",
		"My reply is no", "My sources say no", "Outlook not so good",
		"Very doubtful",
	}
	const prompt = "\n? : "
	fmt.Print("Please enter your question or a blank line to quit.\n" + prompt)
	sc := bufio.NewScanner(os.Stdin)
	for sc.Scan() {
		question := sc.Bytes()
		question = bytes.TrimSpace(question)
		if len(question) == 0 {
			break
		}
		answer := answers[rand.Intn(len(answers))]
		fmt.Printf("\n%s\n"+prompt, answer)
	}
	if err := sc.Err(); err != nil {
		log.Fatal(err)
	}
}
