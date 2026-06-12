package main

import (
   "bufio"
   "fmt"
   "os"
   "sort"
   "strings"
   "unicode"
)

// createCombinations generates all combinations of k characters from the given word
func createCombinations(word string, k int) []string {
   n := len(word)
   if k > n {
      return []string{}
   }

   var combinations []string
   indices := make([]int, k)
   for i := 0; i < k; i++ {
      indices[i] = i
   }

   for {
      // Create combination from current indices
      combination := make([]byte, k)
      for i, idx := range indices {
         combination[i] = word[idx]
      }
      combinations = append(combinations, string(combination))

      // Generate next combination
      if !nextCombination(indices, n, k) {
         break
      }
   }

   return combinations
}

// nextCombination generates the next combination of indices
func nextCombination(indices []int, n, k int) bool {
   for i := k - 1; i >= 0; i-- {
      if indices[i] < n-k+i {
         indices[i]++
         for j := i + 1; j < k; j++ {
            indices[j] = indices[j-1] + 1
         }
         return true
      }
   }
   return false
}

// sortString sorts the characters in a string
func sortString(s string) string {
   runes := []rune(s)
   sort.Slice(runes, func(i, j int) bool {
      return runes[i] < runes[j]
   })
   return string(runes)
}

// removeLetters removes letters from word that are in toRemove (similar to set_difference)
func removeLetters(word, toRemove string) string {
   wordRunes := []rune(word)
   toRemoveRunes := []rune(toRemove)

   // Create a count map for characters to remove
   removeCount := make(map[rune]int)
   for _, r := range toRemoveRunes {
      removeCount[r]++
   }

   var result []rune
   for _, r := range wordRunes {
      if count, exists := removeCount[r]; exists && count > 0 {
         removeCount[r]--
      } else {
         result = append(result, r)
      }
   }

   return string(result)
}

// anagramGenerator finds two-word anagrams for the given word
func anagramGenerator(word string, wordMap map[string][]string) {
   // Remove non-alphabetic characters and convert to lowercase
   cleanWord := ""
   for _, r := range word {
      if unicode.IsLetter(r) {
         cleanWord += string(unicode.ToLower(r))
      }
   }

   // Sort the cleaned word
   sortedWord := sortString(cleanWord)

   previousLetters := make(map[string]bool)

   // Try different combinations from word.size()/2 down to 1
   for n := len(sortedWord) / 2; n >= 1; n-- {
      combinations := createCombinations(sortedWord, n)

      for _, lettersOne := range combinations {
         sortedLettersOne := sortString(lettersOne)

         // Skip if we've seen this combination before
         if previousLetters[sortedLettersOne] {
            continue
         }
         previousLetters[sortedLettersOne] = true

         // Check if this combination exists in word map
         if anagramsOne, exists := wordMap[sortedLettersOne]; exists {
            // Get the remaining letters
            lettersTwo := removeLetters(sortedWord, lettersOne)

            // For equal-length splits, check if we've seen lettersTwo before
            if len(sortedWord) == 2*n {
               if previousLetters[lettersTwo] {
                  continue
               }
            }

            // Check if the remaining letters form valid words
            if anagramsTwo, exists := wordMap[lettersTwo]; exists {
               // Print all combinations
               for _, wordOne := range anagramsOne {
                  for _, wordTwo := range anagramsTwo {
                     fmt.Printf(" %s %s\n", wordOne, wordTwo)
                  }
               }
            }
         }
      }
   }
}

func main() {
   // Build word map from dictionary file
   wordMap := make(map[string][]string)

   file, err := os.Open("unixdict.txt")
   if err != nil {
      fmt.Printf("Error opening file: %v\n", err)
      return
   }
   defer file.Close()

   scanner := bufio.NewScanner(file)
   for scanner.Scan() {
      word := strings.TrimSpace(scanner.Text())
      if word != "" {
         sortedWord := sortString(word)
         wordMap[sortedWord] = append(wordMap[sortedWord], word)
      }
   }

   if err := scanner.Err(); err != nil {
      fmt.Printf("Error reading file: %v\n", err)
      return
   }

   // Test words
   words := []string{"Rosetta code", "Joe B'iden", "Clint Eastw3ood"}

   for _, word := range words {
      fmt.Printf("Two word anagrams of %s:\n", word)
      anagramGenerator(word, wordMap)
      fmt.Println()
   }
}
