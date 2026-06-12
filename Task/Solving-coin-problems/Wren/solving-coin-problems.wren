import "./dynamic" for Struct
import "./pattern" for Pattern
import "./str" for Str
import "./sort" for Sort
import "./fmt" for Fmt

var Kind = Struct.create("Kind", ["name", "value", "number"])

// variable1 = constant1 * variable2 + constant2
var Relation = Struct.create("Relation", ["variable1", "variable2", "constant1", "constant2"])

var nums = {
     "one-half": "0 times", "one": "1", "two": "2", "three": "3", "four": "4", "five": "5",
    "six": "6", "seven": "7", "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12",
    "thirteen": "13", "fourteen": "14", "fifteen": "15", "sixteen": "16", "seventeen": "17",
    "eighteen": "18", "nineteen": "19", "twenty": "20", "thirty": "30", "forty": "40",
    "fifty": "50", "sixty": "60", "seventy": "70", "eighty": "80", "ninety": "90", "hundred": "100"
}

var nums2 = {
    "twenty-": "2", "thirty-": "3", "forty-": "4",
    "fifty-": "5", "sixty-": "6", "seventy-": "7", "eighty-": "8", "ninety-": "9"
}

var coins = {
    "pennies": 0.01, "nickels": 0.05, "dimes": 0.10, "quarters": 0.25, "half-dollars": 0.50,
    "one-dollar": 1.00, "two-dollar": 2.00, "five-dollar": 5.00, "ten-dollar": 10.00
}

var bills = {
    "$1": "one-dollar", "$2": "two-dollar", "$5": "five-dollar", "$10": "ten-dollar"
}

var rx1 = Pattern.new("[/$+1/f|+1/d¢]")
var rx2 = Pattern.new("[pennies|nickels|dimes|quarters|half-dollar|one-dollar|two-dollar|five-dollar|ten-dollar]")
var rx3 = Pattern.new("/s[+1/d]/s")
var rx4 = Pattern.new("[+1/d] times as many [+1/y] as [~she has |][+1/y]")
var rx5 = Pattern.new("[+1/d] more [+1/y] than [~she has |][+1/y]")
var rx6 = Pattern.new("[+1/d] less [+1/y] than [~she has |][+1/y]")
var rx7 = Pattern.new("[+1/d] dollars")

var spaced = Fn.new { |s| " %(s) " }

// Gets a sorted list of monetary values.
var getValues = Fn.new { |q|
    var ss = rx1.findAll(q).map { |m| m.text.trimEnd(".") }.toList
    if (ss.count == 0) return []
    var res = []
    for (s in ss) {
        if (s == "") continue
        if (s[0] == "$") {
            s = s[1..-1]
        } else {
            s = "." + s[0..-3] // '¢' is 2 bytes
        }
        var f = Num.fromString(s)
        res.add(f)
    }
    res.sort()
    return res
}

// Gets a sorted slice of non-monetary integers.
var getNumbers = Fn.new { |q|
    var ns = rx3.findAll(q).map { |m| m.text }.toList
    if (ns.count == 0) return null
    var res = []
    for (n in ns) {
        var i = Num.fromString(n)
        res.add(i)
    }
    res.sort()
    return res
}

// Gets the 'kinds' for the problem.
var getKinds = Fn.new { |a|
    var num = Num.fromString(a[1])
    var kinds = [Kind.new(a[2], 0, 0), Kind.new(a[4], 0, 0)]
    var areCoins = false
    for (i in 0...kinds.count) {
        var v = coins[kinds[i].name]
        if (v) {
            kinds[i].value = v
            areCoins = true
        }
    }
    if (!areCoins) return [0, null]
    return [num, kinds]
}

// Checks if the problem involves 3 coins and
// also returns their names and the names of the coins which occur most.
var hasThreeCoins = Fn.new { |q|
    q = q.replace(".", "").replace(",", "")
    var words = q.split(" ")
    var coinMap = {}
    for (word in words) {
        if (coins.containsKey(word)) {
            var v = coinMap[word]
            if (v) {
                coinMap[word] = v + 1
            } else {
                coinMap[word] = 1
            }
        }
    }
    if (coinMap.count != 3) return [null, "", false]
    var maxNum = 0
    var maxNames = []
    var names = []
    for (me in coinMap) {
        names.add(me.key)
        if (me.value > maxNum) {
            maxNum = me.value
            maxNames = [me.key]
        } else if (me.value == maxNum) {
            maxNames.add(me.key)
        }
    }
    return [names, maxNames, true]
}

var errorMsg = Fn.new { |p|
    System.print(p)
    System.print("*** CAN'T SOLVE THIS ONE ***\n")
}

var printAnswers = Fn.new { |p, kinds|
    System.print(p)
    System.write("ANSWER:")
    var i = 0
    for (kind in kinds) {
        if (i > 0) System.write(",")
        System.write(" %(kind.number) %(kind.name)")
        i = i + 1
    }
    System.print("\n")
}

// Processes a problem which involves 3 coins.
var threeCoins = Fn.new { |p, q, names, maxNames|
    var relations = []
    var am = rx4.findAll(q).map { |m| [m.text] + m.capsText }.toList
    for (i in 0...am.count) {
        var res = getKinds.call(am[i])
        var mult = res[0]
        var kinds = res[1]
        relations.add(Relation.new(kinds[0].name, kinds[1].name, mult, 0))
    }
    var mt = rx5.findAll(q).map { |m| [m.text] + m.capsText }.toList
    for (i in 0...mt.count) {
        var res = getKinds.call(mt[i])
        var plus = res[0]
        var kinds = res[1]
        relations.add(Relation.new(kinds[0].name, kinds[1].name, 1, plus))
    }
    var lt = rx6.findAll(q).map { |m| [m.text] + m.capsText }.toList
    for (i in 0...lt.count) {
        var res = getKinds.call(lt[i])
        var minus = res[0]
        var kinds = res[1]
        relations.add(Relation.new(kinds[0].name, kinds[1].name, 1, -minus))
    }
    var le = relations.count
    if (le > 2) {
        errorMsg.call(p)
        return
    }
    if (le == 0) { // numbers of each coin must be the same
        var sum = 0
        for (name in names) sum = sum + coins[name]
        var tv = getValues.call(q)[-1]
        var n = (tv/sum + 0.5).floor
        var kinds = []
        for (name in names) kinds.add(Kind.new(name, 0, n))
        printAnswers.call(p, kinds)
    } else {
        var totalValue = getValues.call(q)[-1]
        for (maxName in maxNames) {
            for (i in 0...le) {
                if (relations[i].constant1 == 0) {
                    relations[i].constant1 = 0.5 // deals with 'one-half' cases
                }
                if (le == 2 && maxName == relations[i].variable1) {
                    var v = relations[i].variable2
                    relations[i].variable1 = v
                    relations[i].variable2 = maxName
                    relations[i].constant1 = 1 / relations[i].constant1
                    relations[i].constant2 = -relations[i].constant2
                }
            }
            var tv = totalValue
            var v1 = ""
            var v2 = ""
            var v3 = ""
            var n1 = 0
            var n2 = 0
            var n3 = 0
            if (le == 2) {
                var tmc = coins[relations[0].variable1] * relations[0].constant1 +
                    coins[relations[1].variable1] * relations[1].constant1 + coins[maxName]
                tv = tv - coins[relations[0].variable1] * relations[0].constant2 -
                    coins[relations[1].variable1] * relations[1].constant2
                v1 = maxName
                v2 = relations[0].variable1
                v3 = relations[1].variable1
                n1 = (tv/tmc + 0.5).floor
                n2 = (relations[0].constant1*n1 + relations[0].constant2 + 0.5).floor
                n3 = (relations[1].constant1*n1 + relations[1].constant2 + 0.5).floor
            } else {
                var tn = getNumbers.call(q)[-1]
                v1 = relations[0].variable1
                v2 = relations[0].variable2
                for (name in names) {
                    if (name != v1 && name != v2) {
                        v3 = name
                        break
                    }
                }
                var mult1 = coins[v1]
                var mult2 = coins[v2]
                var mult3 = coins[v3]
                n2 = (((tn-relations[0].constant2)*mult3-tv+relations[0].constant2*mult1)/
                    ((relations[0].constant1+1)*mult3-relations[0].constant1*mult1-mult2) + 0.5).floor
                n1 = (n2*relations[0].constant1 + relations[0].constant2 + 0.5).floor
                n3 = tn.floor - n1 - n2
            }
            var calcValue = n1 * coins[v1] + n2 * coins[v2] + n3 * coins[v3]
            if ((totalValue - calcValue).abs <= 1e-14) {
                var kinds = [Kind.new(v1, 0, n1), Kind.new(v2, 0, n2), Kind.new(v3, 0, n3)]
                printAnswers.call(p, kinds)
                return
            }
        }
        errorMsg.call(p)
    }
}

var ps = [
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
    "A person has 12 coins consisting of dimes and pennies. If the total amount of money is $0.30, how many of each coin are there?"
]
for (p in ps) {
    var q = Str.lower(p).replace("twice", "two times").replace(" does ", " has ")
    for (d in ["half", "one", "two", "five", "ten"]) {
        q = q.replace(d + " dollar", d + "-dollar")
    }
    for (me in nums) {
        q = q.replace(spaced.call(me.key), spaced.call(me.value))
    }
    for (me in nums2) {
        q = q.replace(me.key, me.value)
    }
    for (me in nums) {
        q = q.replace(me.key + " ", me.value + " ")
    }
    for (me in bills) {
        q = q.replace(me.key + " ", me.value + " ")
    }
    q = q.replace(" bills", "").replace(" bill", "")
    // check if there are 3 coins involved
    var res = hasThreeCoins.call(q)
    if (res[2]){
        threeCoins.call(p, q, res[0], res[1])
        continue
    }
    var am = rx4.findAll(q).map { |m| [m.text] + m.capsText }.toList
    if (am.count == 1) {
        var res = getKinds.call(am[0])
        var mult = res[0]
        var kinds = res[1]
        if (!kinds) {
            errorMsg.call(p)
            continue
        }
        var tv = getValues.call(q)[-1]
        kinds[1].number = (tv/(mult*kinds[0].value + kinds[1].value) + 0.5).floor
        kinds[0].number = kinds[1].number * mult
        printAnswers.call(p, kinds)
        continue
    }
    var mt = rx5.findAll(q).map { |m| [m.text] + m.capsText }.toList
    if (mt.count == 1) {
        var res = getKinds.call(mt[0])
        var plus = res[0]
        var kinds = res[1]
        if (!kinds) {
            errorMsg.call(p)
            continue
        }
        var tv = getValues.call(q)[-1]
        kinds[1].number = ((tv-plus*kinds[0].value)/(kinds[0].value + kinds[1].value) + 0.5).floor
        kinds[0].number = kinds[1].number + plus
        printAnswers.call(p, kinds)
        continue
    }
    var lt = rx6.findAll(q).map { |m| [m.text] + m.capsText }.toList
    if (lt.count == 1) {
        var res = getKinds.call(lt[0])
        var minus = res[0]
        var kinds = res[1]
        if (!kinds) {
            errorMsg.call(p)
            continue
        }
        var tv = getValues.call(q)[-1]
        kinds[1].number = ((tv+minus*kinds[0].value)/(kinds[0].value + kinds[1].value) + 0.5).floor
        kinds[0].number = kinds[1].number - minus
        printAnswers.call(p, kinds)
        continue
    }
    res = getValues.call(q)
    var tv = 0
    if (res.count > 0) {
        tv = res[-1]
    } else {
        var res3 = rx7.findAll(q).map { |m| [m.text] + m.capsText }.toList
        tv = Num.fromString(res3[0][1])
    }
    var tn = getNumbers.call(q)[-1]
    var coinNames = rx2.findAll(q).map { |m| m.text }.toList
    Sort.insertion(coinNames)
    var kinds = []
    if (coinNames.count > 0) {
        kinds.add(Kind.new(coinNames[0], coins[coinNames[0]], 0))
        for (i in 1...coinNames.count) {
            if (coinNames[i] != coinNames[i-1]) {
                kinds.add(Kind.new(coinNames[i], coins[coinNames[i]], 0))
            }
        }
        if (kinds.count != 2) {
            errorMsg.call(p)
            continue
        }
    } else if (res.count >= 3) {
        kinds.add(Kind.new(Fmt.swrite("$$$.2f item", res[0]), res[0], 0))
        for (i in 1...res.count-1) {
            if (res[i] != res[i-1]) {
                kinds.add(Kind.new(Fmt.swrite("$$$.2f item", res[i]), res[i], 0))
            }
        }
        if (kinds.count!= 2) {
            errorMsg.call(p)
            continue
        }
    } else {
        errorMsg.call(p)
        continue
    }
    kinds[0].number = ((tv-tn*kinds[1].value)/(kinds[0].value-kinds[1].value) + 0.5).floor
    kinds[1].number = tn - kinds[0].number
    printAnswers.call(p, kinds)
}
