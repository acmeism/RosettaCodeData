package main

import "fmt"

var name, lyric, animals = 0, 1, [][]string{
	{"fly", "I don't know why she swallowed a fly. Perhaps she'll die."},
	{"spider", "That wiggled and jiggled and tickled inside her."},
	{"bird", "How absurd, to swallow a bird."},
	{"cat", "Imagine that, she swallowed a cat."},
	{"dog", "What a hog, to swallow a dog."},
	{"goat", "She just opened her throat and swallowed that goat."},
	{"cow", "I don't know how she swallowed that cow."},
	{"horse", "She's dead, of course."},
}

func main() {
	for i, animal := range animals {
		fmt.Printf("There was an old lady who swallowed a %s,\n",
			animal[name])

		if i > 0 {
			fmt.Println(animal[lyric])
		}

		// Swallowing the last animal signals her death, cutting the
		//  lyrics short.
		if i+1 == len(animals) {
			break
		}

		for ; i > 0; i-- {
			fmt.Printf("She swallowed the %s to catch the %s,\n",
				animals[i][name], animals[i-1][name])
		}

		fmt.Println(animals[0][lyric] + "\n")
	}
}
