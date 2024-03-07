import "./dynamic" for Enum
import "./fmt" for Fmt
import "./set" for Set
import "./math" for Nums
import "./sort" for Sort

var Op = Enum.create("Op", ["ADD", "SUB", "JOIN"])

var NUMBER_OF_DIGITS = 9
var THREE_POW_4 = 3 * 3 * 3 * 3
var NUMBER_OF_EXPRESSIONS = 2 * THREE_POW_4 * THREE_POW_4

class Expression {
    static print(givenSum) {
        var expr = Expression.new()
        for (i in 0...NUMBER_OF_EXPRESSIONS) {
            if (expr.toInt == givenSum) Fmt.print("$9d = $s", givenSum, expr)
            expr.inc
        }
    }

    construct new() {
        _code = List.filled(NUMBER_OF_DIGITS, Op.ADD)
    }

    inc {
        for (i in 0..._code.count) {
            _code[i] = (_code[i] == Op.ADD) ? Op.SUB : (_code[i] == Op.SUB) ? Op.JOIN : Op.ADD
            if (_code[i] != Op.ADD) break
        }
        return this
    }

    toInt {
        var value = 0
        var number = 0
        var sign = 1
        for (digit in 1..9) {
            var c = _code[NUMBER_OF_DIGITS - digit]
            if (c == Op.ADD) {
                value = value + sign * number
                number = digit
                sign = 1
            } else if (c == Op.SUB) {
                value = value + sign * number
                number = digit
                sign = -1
            } else {
                number = 10 * number + digit
            }
        }
        return value + sign * number
    }

    toString {
        var sb = ""
        for (digit in 1..NUMBER_OF_DIGITS) {
            var c = _code[NUMBER_OF_DIGITS - digit]
            if (c == Op.ADD) {
                if (digit > 1) sb = sb + " + "
            } else if (c == Op.SUB) {
                sb = sb + " - "
            }
            sb = sb + digit.toString
        }
        return sb.trimStart()
    }
}

class Stat {
    construct new() {
        _countSum = {}
        _sumCount = {}
        var expr = Expression.new()
        for (i in 0...NUMBER_OF_EXPRESSIONS) {
            var sum = expr.toInt
            _countSum[sum] = _countSum[sum] ? 1 + _countSum[sum] : 1
            expr.inc
        }
        for (me in _countSum) {
            var set = _sumCount.containsKey(me.value) ? _sumCount[me.value] : Set.new()
            set.add(me.key)
            _sumCount[me.value] = set
        }
    }

    countSum { _countSum }
    sumCount { _sumCount }
}

System.print("100 has the following solutions:\n")
Expression.print(100)

var stat = Stat.new()
var maxCount = Nums.max(stat.sumCount.keys)
var maxSum = Nums.max(stat.sumCount[maxCount])
System.print("\n%(maxSum) has the maximum number of solutions, namely %(maxCount)")

var value = 0
while (stat.countSum.containsKey(value)) value = value + 1
System.print("\n%(value) is the lowest positive number with no solutions")

System.print("\nThe ten highest numbers that do have solutions are:\n")
var res = stat.countSum.keys.toList
Sort.quick(res)
res[-1..0].take(10).each { |e| Expression.print(e) }
