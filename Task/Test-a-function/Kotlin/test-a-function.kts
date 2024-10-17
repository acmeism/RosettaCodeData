// version 1.1.3

fun isPalindrome(s: String) = (s == s.reversed())

fun main(args: Array<String>) {
    val testCases = listOf("racecar", "alice", "eertree", "david")
    for (testCase in testCases) {
        try {
            assert(isPalindrome(testCase)) { "$testCase is not a palindrome" }
        }
        catch (ae: AssertionError) {
            println(ae.message)
        }
    }
}
