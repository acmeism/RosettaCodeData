package main

import (
    "fmt"
    // "sort"
    "strings"
)

// --- Day Enum Simulation ---

// Day represents a day of the week.
type Day int

// Constants for the days.
const (
    MONDAY Day = iota
    TUESDAY
    WEDNESDAY
    THURSDAY
    FRIDAY
    SATURDAY
    SUNDAY
)

// daysList holds the days in order. This simulates the NavigableSet iteration.
var daysList = []Day{MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}

// String provides the name of the day.
func (d Day) String() string {
    names := map[Day]string{
        MONDAY:    "MONDAY",
        TUESDAY:   "TUESDAY",
        WEDNESDAY: "WEDNESDAY",
        THURSDAY:  "THURSDAY",
        FRIDAY:    "FRIDAY",
        SATURDAY:  "SATURDAY",
        SUNDAY:    "SUNDAY",
    }
    return names[d]
}

// Letters returns the associated letter string for the day.
func (d Day) Letters() string {
    letters := map[Day]string{
        MONDAY:    "HANDYCOILSERUPT",
        TUESDAY:   "SPOILUNDERYACHT",
        WEDNESDAY: "DRAINSTYLEPOUCH",
        THURSDAY:  "DITCHSYRUPALONE",
        FRIDAY:    "SOAPYTHIRDUNCLE",
        SATURDAY:  "SHINEPARTYCLOUD",
        SUNDAY:    "RADIOLUNCHTYPES",
    }
    return letters[d]
}

// Previous returns the preceding day in the cycle.
func (d Day) Previous() Day {
    // Find index of current day
    currentIndex := -1
    for i, day := range daysList {
        if day == d {
            currentIndex = i
            break
        }
    }
    if currentIndex == -1 {
        // Should not happen if d is valid
        panic("Invalid day")
    }
    // Get previous index, wrapping around to the last day if needed
    previousIndex := (currentIndex - 1 + len(daysList)) % len(daysList)
    return daysList[previousIndex]
}

// --- Permutation Struct and Methods ---

// Permutation holds the state for permutation operations.
type Permutation struct {
    lettersCount int
}

// NewPermutation creates a new Permutation instance.
func NewPermutation(lettersCount int) *Permutation {
    return &Permutation{lettersCount: lettersCount}
}

// createOneLine generates the one-line notation for transforming source to destination.
func (p *Permutation) createOneLine(source, destination string) []int {
    result := []int{}
    for _, ch := range destination {
        // Java's indexOf returns -1 if not found, but logic assumes valid inputs.
        // Go's strings.Index returns -1, adding 1 gives 0. Assuming valid inputs.
        indexInSource := strings.IndexRune(source, ch) + 1
        result = append(result, indexInSource)
    }

    // Remove trailing fixed points (where result[i] == i+1)
    for len(result) > 0 && result[len(result)-1] == len(result) {
        result = result[:len(result)-1]
    }
    return result
}

// oneLineToCycles converts one-line notation to cycle notation.
func (p *Permutation) oneLineToCycles(oneLine []int) [][]int {
    cycles := [][]int{}
    used := make(map[int]bool)
    oneLineLen := len(oneLine)

    for number := 1; len(used) < oneLineLen; number++ {
        if !used[number] {
            // Find where 'number' is mapped to in oneLine (1-based index)
            index := -1
            for i, val := range oneLine {
                if val == number {
                    index = i + 1 // Convert to 1-based
                    break
                }
            }

            if index > 0 && index != number { // Only process if it's not a fixed point
                cycle := []int{}
                cycle = append(cycle, number)
                used[number] = true

                current := index
                for current != number {
                    cycle = append(cycle, current)
                    used[current] = true
                    // Find where 'current' is mapped to
                    if current > oneLineLen {
                        // This case handles elements beyond the oneLine length,
                        // assuming they map to themselves (fixed points).
                        // However, the loop logic should prevent this if oneLine is consistent.
                        // Let's stick to the logic: find index of 'current' in oneLine.
                        // If current is not in oneLine, it implies it's a fixed point > len.
                        // But oneLine should define the mapping for 1..len(oneLine).
                        // So, if current > len, it's likely an error or fixed point.
                        // The original Java logic implicitly handles fixed points by stopping
                        // when the cycle closes. Let's re-evaluate the index finding.
                        // index = oneLine.indexOf(current) + 1;
                        // In Go, for current (1-based), we look in oneLine[current-1].
                        // If current > len(oneLine), it's not in the domain of the permutation defined by oneLine.
                        // The loop `len(used) < oneLineLen` ensures we only consider elements within the domain.
                        // So, `number` starts from 1 and goes up to lettersCount, but we only loop
                        // while `len(used) < oneLineLen`. This means we are only processing elements
                        // that are part of the oneLine mapping.
                        // Therefore, `current` should always be within 1..oneLineLen during the cycle building,
                        // because it's derived from values in oneLine.
                        // Let's find the index correctly.
                        currentIndexInOneLine := -1
                        for i, val := range oneLine {
                            if val == current {
                                currentIndexInOneLine = i + 1
                                break
                            }
                        }
                        if currentIndexInOneLine == -1 {
                            // This means 'current' is not in the range of oneLine,
                            // implying it's a fixed point beyond oneLine's defined range.
                            // But the `len(used) < oneLineLen` condition should prevent this path
                            // for elements within the oneLine domain. Let's assume it maps to itself.
                            // However, the cycle building logic `for current != number` should terminate.
                            // If current is a fixed point, oneLine[current-1] == current.
                            // If current > len(oneLine), it's not addressed by oneLine.
                            // The outer loop `for number := 1; ...` iterates up to lettersCount,
                            // but the inner condition `len(used) < oneLineLen` restricts processing.
                            // The discrepancy might be if lettersCount > oneLineLen, but constructor sets them equal.
                            // Let's assume oneLine is correctly sized and represents a permutation of 1..len(oneLine).
                            // Therefore, `current` should always be found in oneLine if it's part of the cycle.
                            // If not found, it's an inconsistency. Let's break the cycle to prevent infinite loop.
                            // But the logic implies it should be found.
                            // Re-examining: `number` starts from 1. We find where 1 maps to (index).
                            // If index != 1, we start a cycle [1, index]. Then we find where index maps to.
                            // This continues until we map back to 1.
                            // The `used` map tracks elements processed. The outer loop `len(used) < oneLineLen`
                            // ensures all elements in oneLine's domain are processed.
                            // The check `if !used[number]` ensures we start a new cycle only for unprocessed elements.
                            // The inner loop builds the cycle correctly based on oneLine.
                            // The potential issue is if oneLine contains invalid data, but assuming valid input.
                            // Let's stick to the correct index finding.
                            current = currentIndexInOneLine // This should correctly advance the cycle
                        } else {
                            current = currentIndexInOneLine
                        }
                    } else {
                        // current is 1-based, oneLine is 0-based
                        current = oneLine[current-1]
                    }
                }

                if len(cycle) > 1 {
                    cycles = append(cycles, cycle)
                }
                // used elements are already marked inside the loop
            } else if index > 0 && index == number {
                // It's a fixed point, mark it as used so we don't process it again
                // if it's within the oneLineLen range.
                used[number] = true
            }
            // If index <= 0, 'number' is not in the image of oneLine. This means it's either
            // outside the domain (number > oneLineLen) or oneLine is malformed.
            // Given the loop condition `len(used) < oneLineLen`, and number starting from 1,
            // number should always be within the domain eventually.
            // If not found, it might be a fixed point not explicitly mentioned in oneLine
            // (if oneLine is shortened). But the trimming in createOneLine handles that.
            // Let's assume oneLine is trimmed correctly and represents a permutation of its indices.
            // Therefore, every number from 1 to oneLineLen should appear in oneLine.
            // If index <= 0 here, it's likely number > oneLineLen, which means it's outside
            // the domain being considered (as loop stops at oneLineLen).
            // So, we can ignore it for cycle formation based on oneLine.
        }
    }
    return cycles
}

// cyclesToOneLine converts cycle notation to one-line notation.
func (p *Permutation) cyclesToOneLine(cycles [][]int) []int {
    oneLine := make([]int, p.lettersCount)
    for i := 0; i < p.lettersCount; i++ {
        oneLine[i] = i + 1 // Initialize to identity permutation
    }

    for number := 1; number <= p.lettersCount; number++ {
        for _, cycle := range cycles {
            index := -1
            for i, val := range cycle {
                if val == number {
                    index = i
                    break
                }
            }
            if index >= 0 {
                // Apply the cycle mapping: number maps to cycle[(index - 1 + size) % size]
                // Which is the element *before* it in the cycle (cyclically).
                // Java: cycle.get(( index - 1 + cycle.size() ) % cycle.size())
                // Go: cycle[(index - 1 + len(cycle)) % len(cycle)]
                prevIndexInCycle := (index - 1 + len(cycle)) % len(cycle)
                oneLine[number-1] = cycle[prevIndexInCycle]
                break // Break after finding the cycle containing 'number'
            }
        }
    }
    return oneLine
}

// cyclesInverse computes the inverse of a permutation given in cycle form.
func (p *Permutation) cyclesInverse(cycles [][]int) [][]int {
    cyclesInverse := make([][]int, len(cycles))
    for i, cycle := range cycles {
        // Create a copy of the cycle
        newCycle := make([]int, len(cycle))
        copy(newCycle, cycle)
        cyclesInverse[i] = newCycle

        // Inverse the cycle: [a, b, c] -> [a, c, b] then reverse -> [b, c, a] -> [c, b, a]
        // Or more simply: rotate left by 1, then reverse.
        // Java: addLast(removeFirst()), then reverse.
        if len(newCycle) > 1 {
            // Remove first, add to last: [a,b,c] -> [b,c,a]
            first := newCycle[0]
            copy(newCycle, newCycle[1:])
            newCycle[len(newCycle)-1] = first
            // Reverse: [b,c,a] -> [a,c,b]
            for j, k := 0, len(newCycle)-1; j < k; j, k = j+1, k-1 {
                newCycle[j], newCycle[k] = newCycle[k], newCycle[j]
            }
        }
        // For length 1, inverse is itself, no change needed.
    }
    return cyclesInverse
}

// oneLineInverse computes the inverse of a permutation given in one-line form.
func (p *Permutation) oneLineInverse(oneLine []int) []int {
    oneLineInverse := make([]int, len(oneLine))
    // Initialize with a placeholder (0), assuming valid input 1-based indices
    // Java uses 0 initially, then sets values.

    for number := 1; number <= len(oneLine); number++ {
        // Find the index (0-based) where 'number' appears in oneLine
        indexOfNumberInOneLine := -1
        for i, val := range oneLine {
            if val == number {
                indexOfNumberInOneLine = i
                break
            }
        }
        // The inverse map: if oneLine maps index i to number,
        // then oneLineInverse maps number to i+1 (1-based index).
        if indexOfNumberInOneLine != -1 {
            oneLineInverse[number-1] = indexOfNumberInOneLine + 1
        } else {
            // This case should not happen if oneLine is a valid permutation
            // of 1 to len(oneLine). Placeholder or error handling could go here.
            oneLineInverse[number-1] = 0 // Or number itself if fixed point?
        }
    }
    return oneLineInverse
}

// next applies a permutation given in cycle form to a number.
func (p *Permutation) next(number int, cycles [][]int) int {
    for _, cycle := range cycles {
        for i, val := range cycle {
            if val == number {
                // Map to the next element in the cycle (cyclically)
                nextIndex := (i + 1) % len(cycle)
                return cycle[nextIndex]
            }
        }
    }
    // If not found in any cycle, it's a fixed point
    return number
}

// combinedCycles computes the composition of two permutations in cycle form (cyclesOne then cyclesTwo).
func (p *Permutation) combinedCycles(cyclesOne, cyclesTwo [][]int) [][]int {
    combinedCyclesResult := [][]int{}
    used := make(map[int]bool)

    for number := 1; len(used) < p.lettersCount; number++ {
        if !used[number] {
            // Apply cyclesOne, then cyclesTwo
            combined := p.next(p.next(number, cyclesOne), cyclesTwo)
            if combined != number { // Only create a cycle if it's not a fixed point
                cycle := []int{}
                cycle = append(cycle, number)
                used[number] = true

                current := combined
                for current != number {
                    cycle = append(cycle, current)
                    used[current] = true
                    current = p.next(p.next(current, cyclesOne), cyclesTwo)
                }

                if len(cycle) > 1 {
                    combinedCyclesResult = append(combinedCyclesResult, cycle)
                }
            } else {
                // Fixed point, mark as used
                used[number] = true
            }
        }
    }
    return combinedCyclesResult
}

// oneLinePermuteString applies a permutation in one-line form to a string.
func (p *Permutation) oneLinePermuteString(text string, oneLine []int) string {
    if len(text) < len(oneLine) {
        // Handle case where text is shorter than the permutation domain
        // Java code implicitly pads or assumes matching length.
        // Let's assume matching length or truncate oneLine.
        // For simplicity, assume text and oneLine length match for the operation.
        // If oneLine is shorter, the rest of text is appended.
        // Original logic: addLast(text.substring(permuted.size()))
        // This suggests text can be longer, and oneLine defines the shuffle for the first part.
    }
    permutedRunes := make([]rune, len(text))
    textRunes := []rune(text) // Handle potential multi-byte characters

    for i, index := range oneLine {
        // oneLine contains 1-based indices
        if index >= 1 && index <= len(textRunes) {
            permutedRunes[i] = textRunes[index-1]
        } else {
            // Handle invalid index? Assume valid input or use placeholder?
            // Java would likely throw StringIndexOutOfBoundsException or use default.
            // Let's assume valid input matching lengths or index within bounds.
        }
    }

    // Append the part of the text not covered by oneLine
    // Java: permuted.addLast(text.substring(permuted.size()));
    if len(oneLine) < len(textRunes) {
        permutedRunes = append(permutedRunes, textRunes[len(oneLine):]...)
    } else if len(oneLine) > len(textRunes) {
        // This case might lead to index out of bounds above, but let's handle gracefully
        // by only using the part of oneLine that fits.
        // The primary assumption is oneLine length <= text length for this operation.
        // If oneLine is longer, the extra elements are ignored in the loop.
        // The append step handles text being longer.
        // If text is shorter than oneLine, accessing textRunes[index-1] will panic if index > len(text).
        // Let's re-evaluate: assume oneLine length determines the shuffle part.
        permutedRunes = permutedRunes[:len(oneLine)] // Truncate if oneLine is longer than initialized slice
        // But initialization was len(text). If oneLine > text, initialization is wrong.
        // Let's make permutedRunes size match oneLine initially, then append.
        // Actually, let's stick closer to the logic:
        // Iterate oneLine. For each index, get char from text. Append rest of text.
        // So, permuted slice should be built dynamically or sized to max possible.
        // Let's re-implement slightly cleaner:
        // permuted := make([]string, 0, len(text)) // capacity hint
        // for _, index := range oneLine { ... permuted = append(permuted, string(textRunes[index-1])) }
        // permuted = append(permuted, text[len(oneLine):])
        // return strings.Join(permuted, "")
        // Using runes for clarity and potential unicode safety.
        permutedStrings := make([]string, 0, len(textRunes))
        for _, index := range oneLine {
            if index >= 1 && index <= len(textRunes) {
                permutedStrings = append(permutedStrings, string(textRunes[index-1]))
            }
        }
        // Append remaining part of text not covered by oneLine indices
        if len(oneLine) < len(textRunes) {
            permutedStrings = append(permutedStrings, string(textRunes[len(oneLine):]))
        }
        return strings.Join(permutedStrings, "")
    }

    return string(permutedRunes)
}

// cyclesPermuteString applies a permutation in cycle form to a string.
func (p *Permutation) cyclesPermuteString(text string, cycles [][]int) string {
    textRunes := []rune(text)
    permutedRunes := make([]rune, len(textRunes))
    copy(permutedRunes, textRunes) // Start with a copy

    for _, cycle := range cycles {
        for _, number := range cycle {
            // Determine where 'number' (1-based index) maps to under the cycles
            nextNumber := p.next(number, cycles)
            // Place the character from the original text at position 'number'
            // into the new position 'nextNumber' in the permuted slice.
            // Go slices are 0-based.
            if number >= 1 && number <= len(textRunes) && nextNumber >= 1 && nextNumber <= len(textRunes) {
                permutedRunes[nextNumber-1] = textRunes[number-1]
            }
        }
    }

    return string(permutedRunes)
}

// gcd calculates the greatest common divisor using Euclidean algorithm.
func (p *Permutation) gcd(a, b int) int {
    for b != 0 {
        a, b = b, a%b
    }
    return a
}

// signature calculates the signature of a permutation given in one-line form.
func (p *Permutation) signature(oneLine []int) string {
    cycles := p.oneLineToCycles(oneLine)
    evenCount := 0
    for _, cycle := range cycles {
        if len(cycle)%2 == 0 {
            evenCount++
        }
    }
    if evenCount%2 == 0 {
        return "+1"
    }
    return "-1"
}

// order calculates the order of a permutation given in one-line form.
func (p *Permutation) order(oneLine []int) int {
    cycles := p.oneLineToCycles(oneLine)
    lcm := 1
    for _, cycle := range cycles {
        size := len(cycle)
        // Calculate LCM: lcm = lcm * size / gcd(lcm, size)
        g := p.gcd(lcm, size)
        lcm = lcm / g * size // Avoid potential overflow, do division first
    }
    return lcm
}

// --- Main Function ---

func main() {
    const lettersCount = 15 // Length of the day strings
    permutation := NewPermutation(lettersCount)

    fmt.Println("On Thursdays Alf and Betty should rearrange their letters using these cycles:")
    oneLineWedThu := permutation.createOneLine(WEDNESDAY.Letters(), THURSDAY.Letters())
    cyclesWedThu := permutation.oneLineToCycles(oneLineWedThu)
    fmt.Println(cyclesWedThu)
    fmt.Printf("So that %s becomes %s\n", WEDNESDAY.Letters(), THURSDAY.Letters())

    fmt.Println("\nOr they could use the one line notation:")
    fmt.Println(oneLineWedThu)

    fmt.Println("\nTo revert to the Wednesday arrangement they should use these cycles:")
    cyclesThuWed := permutation.cyclesInverse(cyclesWedThu)
    fmt.Println(cyclesThuWed)

    fmt.Println("\nOr with the one line notation:")
    oneLineThuWed := permutation.oneLineInverse(oneLineWedThu)
    fmt.Println(oneLineThuWed)
    fmt.Printf("So that %s becomes %s\n", THURSDAY.Letters(), permutation.oneLinePermuteString(THURSDAY.Letters(), oneLineThuWed))

    fmt.Println("\nStarting with the Sunday arrangement and applying each of the daily")
    fmt.Printf("arrangements consecutively, the arrangements will be:\n\n      %s\n\n", SUNDAY.Letters())

    for _, day := range daysList {
        dayOneLine := permutation.createOneLine(day.Previous().Letters(), day.Letters())
        result := permutation.oneLinePermuteString(day.Previous().Letters(), dayOneLine)
        // Format similar to Java's String.format
        fmt.Printf("%11s%s", day.String()+": ", result)
        if day == SATURDAY {
            fmt.Println() // Extra newline after Saturday
        } else {
            fmt.Println()
        }
    }

    fmt.Println("\nTo go from Wednesday to Friday in a single step they should use these cycles:")
    oneLineThuFri := permutation.createOneLine(THURSDAY.Letters(), FRIDAY.Letters())
    cyclesThuFri := permutation.oneLineToCycles(oneLineThuFri)
    cyclesWedFri := permutation.combinedCycles(cyclesWedThu, cyclesThuFri)
    fmt.Println(cyclesWedFri)
    fmt.Printf("So that %s becomes %s\n", WEDNESDAY.Letters(), permutation.cyclesPermuteString(WEDNESDAY.Letters(), cyclesWedFri))

    fmt.Println("\nThese are the signatures of the permutations:\n")
    for _, day := range daysList {
        oneLine := permutation.createOneLine(day.Previous().Letters(), day.Letters())
        sig := permutation.signature(oneLine)
        fmt.Printf("%11s%s\n", day.String()+": ", sig)
    }

    fmt.Println("\nThese are the orders of the permutations:\n")
    for _, day := range daysList {
        oneLine := permutation.createOneLine(day.Previous().Letters(), day.Letters())
        ord := permutation.order(oneLine)
        fmt.Printf("%11s%d\n", day.String()+": ", ord)
    }

    fmt.Println("\nApplying the Friday cycle to a string 10 times:")
    word := "STOREDAILYPUNCH"
    fmt.Printf("\n 0 %s\n", word)
    for i := 1; i <= 10; i++ {
        word = permutation.cyclesPermuteString(word, cyclesThuFri)
        if i == 9 {
            fmt.Printf("%2d %s\n", i, word) // Extra newline after iteration 9
        } else {
            fmt.Printf("%2d %s\n", i, word)
        }
    }
}
