package main

import (
    "fmt"
    "math"
    "regexp"
    "sort"
    "strconv"
    "strings"
)

type kind struct {
    name   string
    value  float64
    number int
}

// variable1 = constant1 * variable2 + constant2
type relation struct {
    variable1 string
    variable2 string
    constant1 float64
    constant2 float64
}

var nums = map[string]string{
    "one-half": "0 times", "one": "1", "two": "2", "three": "3", "four": "4", "five": "5",
    "six": "6", "seven": "7", "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12",
    "thirteen": "13", "fourteen": "14", "fifteen": "15", "sixteen": "16", "seventeen": "17",
    "eighteen": "18", "nineteen": "19", "twenty": "20", "thirty": "30", "forty": "40",
    "fifty": "50", "sixty": "60", "seventy": "70", "eighty": "80", "ninety": "90",
    "hundred": "100"}

var nums2 = map[string]string{
    "twenty-": "2", "thirty-": "3", "forty-": "4",
    "fifty-": "5", "sixty-": "6", "seventy-": "7", "eighty-": "8", "ninety-": "9"}

var coins = map[string]float64{
    "pennies": 0.01, "nickels": 0.05, "dimes": 0.10, "quarters": 0.25, "half-dollars": 0.50,
    "one-dollar": 1.00, "two-dollar": 2.00, "five-dollar": 5.00, "ten-dollar": 10.00}

var bills = map[string]string{
    "$1": "one-dollar", "$2": "two-dollar", "$5": "five-dollar", "$10": "ten-dollar"}

var (
    rx1 = regexp.MustCompile(`\$\d+(\.\d+)?|\d+¢`)
    rx2 = regexp.MustCompile(`\b(pennies|nickels|dimes|quarters|half-dollar|one-dollar|two-dollar|five-dollar|ten-dollar)\b`)
    rx3 = regexp.MustCompile(`\s(\d+)\s`)
    rx4 = regexp.MustCompile(`(\d+) times as many ([-\w]+) as (s?he (does|has) )?([-\w]+)`)
    rx5 = regexp.MustCompile(`(\d+) more ([-\w]+) than (s?he (does|has) )?([-\w]+)`)
    rx6 = regexp.MustCompile(`(\d+) less ([-\w]+) than (s?he (does|has) )?([-\w]+)`)
    rx7 = regexp.MustCompile(`(\d+) dollars`)
)

func spaced(s string) string {
    return fmt.Sprintf(" %s ", s)
}

// Gets a sorted slice of monetary values.
func getValues(q string) []float64 {
    ss := rx1.FindAllString(q, -1)
    if ss == nil {
        return nil
    }
    var res []float64
    for _, s := range ss {
        if len(s) == 0 {
            continue
        }
        if s[0] == '$' {
            s = s[1:]
        } else {
            s = "." + s[:len(s)-2] // '¢' is 2 bytes
        }
        f, _ := strconv.ParseFloat(s, 64)
        res = append(res, f)
    }
    sort.Float64s(res)
    return res
}

// Gets a sorted slice of non-monetary integers.
func getNumbers(q string) []int {
    ns := rx3.FindAllString(q, -1)
    if ns == nil {
        return nil
    }
    var res []int
    for _, n := range ns {
        i, _ := strconv.Atoi(strings.TrimSpace(n))
        res = append(res, i)
    }
    sort.Ints(res)
    return res
}

// Gets the 'kinds' for the problem.
func getKinds(a []string) (int, []kind) {
    num, _ := strconv.Atoi(a[1])
    kinds := []kind{{a[2], 0, 0}, {a[5], 0, 0}}
    areCoins := false
    for i := range kinds {
        if v, ok := coins[kinds[i].name]; ok {
            kinds[i].value = v
            areCoins = true
        }
    }
    if !areCoins {
        return 0, nil
    }
    return num, kinds
}

// Checks if the problem involves 3 coins and
// also returns their names and the names of the coin which occurs most.
func hasThreeCoins(q string) ([]string, []string, bool) {
    q = strings.ReplaceAll(q, ".", "")
    q = strings.ReplaceAll(q, ",", "")
    words := strings.Split(q, " ")
    coinMap := make(map[string]int)
    for _, word := range words {
        if _, ok := coins[word]; ok {
            coinMap[word]++
        }
    }
    if len(coinMap) != 3 {
        return nil, []string{}, false
    }
    maxNum := 0
    var maxNames []string
    var names []string
    for k, v := range coinMap {
        names = append(names, k)
        if v > maxNum {
            maxNum = v
            maxNames = maxNames[:0]
            maxNames = append(maxNames, k)
        } else if v == maxNum {
            maxNames = append(maxNames, k)
        }
    }
    return names, maxNames, true
}

// Processes a problem which involves 3 coins.
func threeCoins(p, q string, names, maxNames []string) {
    var relations []relation
    am := rx4.FindAllStringSubmatch(q, -1)
    for i := 0; i < len(am); i++ {
        mult, kinds := getKinds(am[i])
        relations = append(relations, relation{kinds[0].name, kinds[1].name, float64(mult), 0})
    }
    mt := rx5.FindAllStringSubmatch(q, -1)
    for i := 0; i < len(mt); i++ {
        plus, kinds := getKinds(mt[i])
        relations = append(relations, relation{kinds[0].name, kinds[1].name, 1, float64(plus)})
    }
    lt := rx6.FindAllStringSubmatch(q, -1)
    for i := 0; i < len(lt); i++ {
        minus, kinds := getKinds(lt[i])
        relations = append(relations, relation{kinds[0].name, kinds[1].name, 1, -float64(minus)})
    }
    le := len(relations)
    if le > 2 {
        errorMsg(p)
        return
    }
    if le == 0 { // numbers of each coin must be the same
        sum := 0.0
        for _, name := range names {
            sum += coins[name]
        }
        res := getValues(q)
        tv := res[len(res)-1]
        n := int(tv/sum + 0.5)
        var kinds []kind
        for _, name := range names {
            kinds = append(kinds, kind{name, 0, n})
        }
        printAnswers(p, kinds)
    } else {
        res := getValues(q)
        totalValue := res[len(res)-1]
        for _, maxName := range maxNames {
            for i := 0; i < le; i++ {
                if relations[i].constant1 == 0 {
                    relations[i].constant1 = 0.5 // deals with 'one-half' cases
                }
                if le == 2 && maxName == relations[i].variable1 {
                    v := relations[i].variable2
                    relations[i].variable1, relations[i].variable2 = v, maxName
                    relations[i].constant1 = 1 / relations[i].constant1
                    relations[i].constant2 = -relations[i].constant2
                }
            }
            tv := totalValue
            var v1, v2, v3 string
            var n1, n2, n3 int
            if le == 2 {
                tmc := coins[relations[0].variable1]*relations[0].constant1 +
                    coins[relations[1].variable1]*relations[1].constant1 + coins[maxName]
                tv -= coins[relations[0].variable1]*relations[0].constant2 +
                    coins[relations[1].variable1]*relations[1].constant2
                v1, v2, v3 = maxName, relations[0].variable1, relations[1].variable1
                n1 = int(tv/tmc + 0.5)
                n2 = int(relations[0].constant1*float64(n1) + relations[0].constant2 + 0.5)
                n3 = int(relations[1].constant1*float64(n1) + relations[1].constant2 + 0.5)
            } else {
                res2 := getNumbers(q)
                tn := float64(res2[len(res2)-1])
                v1, v2 = relations[0].variable1, relations[0].variable2
                for _, name := range names {
                    if name != v1 && name != v2 {
                        v3 = name
                        break
                    }
                }
                mult1, mult2, mult3 := coins[v1], coins[v2], coins[v3]
                n2 = int(((tn-relations[0].constant2)*mult3-tv+relations[0].constant2*mult1)/
                    ((relations[0].constant1+1)*mult3-relations[0].constant1*mult1-mult2) + 0.5)
                n1 = int(float64(n2)*relations[0].constant1 + relations[0].constant2 + 0.5)
                n3 = int(tn) - n1 - n2
            }
            calcValue := float64(n1)*coins[v1] + float64(n2)*coins[v2] + float64(n3)*coins[v3]
            if math.Abs(totalValue-calcValue) <= 1e-14 {
                kinds := []kind{kind{v1, 0, n1}, kind{v2, 0, n2}, kind{v3, 0, n3}}
                printAnswers(p, kinds)
                return
            }
        }
        errorMsg(p)
    }
    return
}

func printAnswers(p string, kinds []kind) {
    fmt.Println(p)
    fmt.Print("ANSWER:")
    for i, kind := range kinds {
        if i > 0 {
            fmt.Print(",")
        }
        fmt.Printf(" %d %s", kind.number, kind.name)
    }
    fmt.Println("\n")
}

func errorMsg(p string) {
    fmt.Println(p)
    fmt.Println("*** CAN'T SOLVE THIS ONE ***\n")
}

func main() {
    ps := []string{
        "If a person has three times as many quarters as dimes and the total amount of money is $5.95, find the number of quarters and dimes.",
        "A pile of 18 coins consists of pennies and nickels. If the total amount of the coins is 38¢, find the number of pennies and nickels.",
        "A small child has 6 more quarters than nickels. If the total amount of coins is $3.00, find the number of nickels and quarters the child has.",
        "A child's bank contains 32 coins consisting of nickels and quarters. If the total amount of money is $3.80, find the number of nickels and quarters in the bank.",
        "A person has twice as many dimes as she has pennies and three more nickels than pennies. If the total amount of the coins is $1.97, find the numbers of each type of coin the person has.",
        "In a bank, there are three times as many quarters as half dollars and 6 more dimes than half dollars. If the total amount of the money in the bank is $4.65, find the number of each type of coin in the bank.",
        "A person bought 12 stamps consisting of 37¢ stamps and 23¢ stamps. If the cost of the stamps is $3.74, find the number of each type of the stamps purchased.",
        "A dairy store sold a total of 80 ice cream sandwiches and ice cream bars. If the sandwiches cost $0.69 each and the bars cost $0.75 each and the store made $58.08, find the number of each sold.",
        "An office supply store sells college-ruled notebook paper for $1.59 a ream and wide-ruled notebook paper for $2.29 a ream. If a student purchased 9 reams of notebook paper and paid $15.71, how many reams of each type of paper did the student purchase?",
        "A clerk is given $75 in bills to put in a cash drawer at the start of a workday. There are twice as many $1 bills as $5 bills and one less $10 bill than $5 bills. How many of each type of bill are there?",
        "A person has 8 coins consisting of quarters and dimes. If the total amount of this change is $1.25, how many of each kind of coin are there?",
        "A person has 3 times as many dimes as he has nickels and 5 more pennies than nickels. If the total amount of these coins is $1.13, how many of each kind of coin does he have?",
        "A person bought ten greeting cards consisting of birthday cards costing $1.50 each and anniversary cards costing $2.00 each. If the total cost of the cards was $17.00, find the number of each kind of card the person bought.",
        "A person has 9 more dimes than nickels. If the total amount of money is $1.20, find the number of dimes the person has.",
        "A person has 20 bills consisting of $1 bills and $2 bills. If the total amount of money the person has is $35, find the number of $2 bills the person has.",
        "A bank contains 8 more pennies than nickels and 3 more dimes than nickels. If the total amount of money in the bank is $3.10, find the number of dimes in the bank.",
        "Your uncle walks in, jingling the coins in his pocket. He grins at you and tells you that you can have all the coins if you can figure out how many of each kind of coin he is carrying. You're not too interested until he tells you that he's been collecting those gold-tone one-dollar coins. The twenty-six coins in his pocket are all dollars and quarters, and they add up to seventeen dollars in value. How many of each coin does he have?",
        "A collection of 33 coins, consisting of nickels, dimes, and quarters, has a value of $3.30. If there are three times as many nickels as quarters, and one-half as many dimes as nickels, how many coins of each kind are there?",
        "A wallet contains the same number of pennies, nickels, and dimes. The coins total $1.44. How many of each type of coin does the wallet contain?",
        "Suppose Ken has 25 coins in nickels and dimes only and has a total of $1.65. How many of each coin does he have?",
        "Terry has 2 more quarters than dimes and has a total of $6.80. The number of quarters and dimes is 38. How many quarters and dimes does Terry have?",
        "In my wallet, I have one-dollar bills, five-dollar bills, and ten-dollar bills. The total amount in my wallet is $43. I have four times as many one-dollar bills as ten-dollar bills. All together, there are 13 bills in my wallet. How many of each bill do I have?",
        "Marsha has three times as many one-dollar bills as she does five dollar bills. She has a total of $32. How many of each bill does she have?",
        "A vending machine has $41.25 in it. There are 255 coins total and the machine only accepts nickels, dimes and quarters. There are twice as many dimes as nickels. How many of each coin are in the machine?",
        "Michael had 27 coins in all, valuing $4.50. If he had only quarters and dimes, how many coins of each kind did he have?",
        "Lucille had $13.25 in nickels and quarters. If she had 165 coins in all, how many of each type of coin did she have?",
        "Ben has $45.25 in quarters and dimes. If he has 29 less quarters than dimes, how many of each type of coin does he have?",
        "A person has 12 coins consisting of dimes and pennies. If the total amount of money is $0.30, how many of each coin are there?",
    }
    for _, p := range ps {
        q := strings.ToLower(p)
        q = strings.ReplaceAll(q, "twice", "two times")
        for _, d := range []string{"half", "one", "two", "five", "ten"} {
            q = strings.ReplaceAll(q, d+" dollar", d+"-dollar")
        }
        for k, v := range nums {
            q = strings.ReplaceAll(q, spaced(k), spaced(v))
        }
        for k, v := range nums2 {
            q = strings.ReplaceAll(q, k, v)
        }
        for k, v := range nums {
            q = strings.ReplaceAll(q, k+" ", v+" ")
        }
        for k, v := range bills {
            q = strings.ReplaceAll(q, k+" ", v+" ")
        }
        q = strings.ReplaceAll(q, " bills", "")
        q = strings.ReplaceAll(q, " bill", "")
        // check if there are 3 coins involved
        if names, maxNames, ok := hasThreeCoins(q); ok {
            threeCoins(p, q, names, maxNames)
            continue
        }
        am := rx4.FindAllStringSubmatch(q, -1)
        if len(am) == 1 {
            mult, kinds := getKinds(am[0])
            if kinds == nil {
                errorMsg(p)
                continue
            }
            res := getValues(q)
            tv := res[len(res)-1]
            fmult := float64(mult)
            kinds[1].number = int(tv/(fmult*kinds[0].value+kinds[1].value) + 0.5)
            kinds[0].number = kinds[1].number * mult
            printAnswers(p, kinds)
            continue
        }
        mt := rx5.FindAllStringSubmatch(q, -1)
        if len(mt) == 1 {
            plus, kinds := getKinds(mt[0])
            if kinds == nil {
                errorMsg(p)
                continue
            }
            res := getValues(q)
            tv := res[len(res)-1]
            fplus := float64(plus)
            kinds[1].number = int((tv-fplus*kinds[0].value)/(kinds[0].value+kinds[1].value) + 0.5)
            kinds[0].number = kinds[1].number + plus
            printAnswers(p, kinds)
            continue
        }
        lt := rx6.FindAllStringSubmatch(q, -1)
        if len(lt) == 1 {
            minus, kinds := getKinds(lt[0])
            if kinds == nil {
                errorMsg(p)
                continue
            }
            res := getValues(q)
            tv := res[len(res)-1]
            fminus := float64(minus)
            kinds[1].number = int((tv+fminus*kinds[0].value)/(kinds[0].value+kinds[1].value) + 0.5)
            kinds[0].number = kinds[1].number - minus
            printAnswers(p, kinds)
            continue
        }
        res := getValues(q)
        var tv float64
        if len(res) > 0 {
            tv = res[len(res)-1]
        } else {
            res3 := rx7.FindAllStringSubmatch(q, -1)
            i, _ := strconv.Atoi(res3[0][1])
            tv = float64(i)
        }
        res2 := getNumbers(q)
        tn := res2[len(res2)-1]
        coinNames := rx2.FindAllString(q, -1)
        sort.Strings(coinNames)
        var kinds []kind
        if len(coinNames) > 0 {
            kinds = append(kinds, kind{coinNames[0], coins[coinNames[0]], 0})
            for i := 1; i < len(coinNames); i++ {
                if coinNames[i] != coinNames[i-1] {
                    kinds = append(kinds, kind{coinNames[i], coins[coinNames[i]], 0})
                }
            }
            if len(kinds) != 2 {
                errorMsg(p)
                continue
            }
        } else if len(res) >= 3 {
            kinds = append(kinds, kind{fmt.Sprintf("$%.2f item", res[0]), res[0], 0})
            for i := 1; i < len(res)-1; i++ {
                if res[i] != res[i-1] {
                    kinds = append(kinds, kind{fmt.Sprintf("$%.2f item", res[i]), res[i], 0})
                }
            }
            if len(kinds) != 2 {
                errorMsg(p)
                continue
            }
        } else {
            errorMsg(p)
            continue
        }
        ftn := float64(tn)
        kinds[0].number = int((tv-ftn*kinds[1].value)/(kinds[0].value-kinds[1].value) + 0.5)
        kinds[1].number = tn - kinds[0].number
        printAnswers(p, kinds)
    }
}
