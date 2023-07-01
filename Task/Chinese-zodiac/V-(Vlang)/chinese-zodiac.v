const (
    animal_string = ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
        "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"]
    stem_yy_string  = ["Yang", "Yin"]
    element_string = ["Wood", "Fire", "Earth", "Metal", "Water"]
    stem_ch        = "甲乙丙丁戊己庚辛壬癸".split('')
    branch_ch      = "子丑寅卯辰巳午未申酉戌亥".split('')
)

fn cz(y int) (string, string, string, string, int) {
    yr := y-4
    stem := yr % 10
    branch := yr % 12
    return animal_string[branch],
        stem_yy_string[stem%2],
        element_string[stem/2],
        [stem_ch[stem], branch_ch[branch]].join(''),
        yr%60 + 1
}

fn main() {
    for yr in [1935, 1938, 1968, 1972, 1976] {
        a, yy, e, sb, cy := cz(yr)
        println("$yr: $e $a, $yy, Cycle year $cy $sb")
    }
}
