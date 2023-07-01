const numerals = {1000:"M", 900:"CM", 500:"D", 400:"CD", 100:"C",
 90:"XC", 50:"L", 40: "XL", 10:"X", 9:"IX", 5:"V", 4:"IV", 1:"I"}

fn main() {
    println(encode(1990))
    println(encode(2008))
    println(encode(1666))
}

fn encode(number int) string {
    mut num := number
    mut result := ""
    if number < 1 || number > 5000 {return result}
    for digit, roman in numerals {
        for num >= digit {
            num -= digit
            result += roman
        }
    }
    return result
}
