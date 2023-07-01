package main

import "fmt"

var (
    animalString = []string{"Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
        "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"}
    stemYYString  = []string{"Yang", "Yin"}
    elementString = []string{"Wood", "Fire", "Earth", "Metal", "Water"}
    stemCh        = []rune("甲乙丙丁戊己庚辛壬癸")
    branchCh      = []rune("子丑寅卯辰巳午未申酉戌亥")
)

func cz(yr int) (animal, yinYang, element, stemBranch string, cycleYear int) {
    yr -= 4
    stem := yr % 10
    branch := yr % 12
    return animalString[branch],
        stemYYString[stem%2],
        elementString[stem/2],
        string([]rune{stemCh[stem], branchCh[branch]}),
        yr%60 + 1
}

func main() {
    for _, yr := range []int{1935, 1938, 1968, 1972, 1976} {
        a, yy, e, sb, cy := cz(yr)
        fmt.Printf("%d: %s %s, %s, Cycle year %d %s\n",
            yr, e, a, yy, cy, sb)
    }
}
