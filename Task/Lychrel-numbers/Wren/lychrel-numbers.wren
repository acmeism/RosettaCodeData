import "/big" for BigInt
import "/set" for Set

var iterations = 500
var limit = 10000
var bigLimit = BigInt.new(limit)

// In the sieve,  0 = not Lychrel, 1 = Seed Lychrel, 2 = Related Lychrel
var lychrelSieve    = List.filled(limit + 1, 0)
var seedLychrels    = []
var relatedLychrels = Set.new()

var isPalindrome = Fn.new { |bi|
    var s = bi.toString
    return s == s[-1..0]
}

var lychrelTest = Fn.new { |i, seq|
    if (i < 1) return
    var bi = BigInt.new(i)
    for (j in 1..iterations) {
        bi = bi + BigInt.new(bi.toString[-1..0])
        seq.add(bi)
        if (isPalindrome.call(bi)) return
    }
    for (j in 0...seq.count) {
        if (seq[j] <= bigLimit) {
            lychrelSieve[seq[j].toSmall] = 2
        } else {
            break
        }
    }
    var sizeBefore = relatedLychrels.count
    // if all of these can be added 'i' must be a seed Lychrel
    relatedLychrels.addAll(seq.map { |i| i.toString }) // can't add BigInts directly to a Set
    if (relatedLychrels.count - sizeBefore == seq.count) {
        seedLychrels.add(i)
        lychrelSieve[i] = 1
    } else {
        relatedLychrels.add(i.toString)
        lychrelSieve[i] = 2
    }
}

var seq = []
for (i in 1..limit) {
    if (lychrelSieve[i] == 0) {
        seq.clear()
        lychrelTest.call(i, seq)
    }
}
var related = lychrelSieve.count { |i| i == 2 }
System.print("Lychrel numbers in the range [1, %(limit)]")
System.print("Maximum iterations = %(iterations)")
System.print("\nThere are %(seedLychrels.count) seed Lychrel numbers, namely:")
System.print(seedLychrels)
System.print("\nThere are also %(related) related Lychrel numbers in this range.")
var palindromes = []
for (i in 1..limit) {
    if (lychrelSieve[i] > 0 && isPalindrome.call(BigInt.new(i))) palindromes.add(i)
}
System.print("\nThere are %(palindromes.count) palindromic Lychrel numbers, namely:")
System.print(palindromes)
