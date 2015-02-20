  // Testing
  assert(!isPalindrome(""))
  assert(!isPalindrome("z"))
  assert(isPalindrome("amanaplanacanalpanama"))
  assert(!isPalindrome("Test 1,2,3"))
  assert(isPalindrome("1 2 1"))
  assert(!isPalindrome("A man a plan a canal Panama."))

  assert(!isPalindromeSentence(""))
  assert(!isPalindromeSentence("z"))
  assert(isPalindromeSentence("amanaplanacanalpanama"))
  assert(!isPalindromeSentence("Test 1,2,3"))
  assert(isPalindromeSentence("1 2 1"))
  assert(isPalindromeSentence("A man a plan a canal Panama."))

  assert(!isPalindromeRec(""))
  assert(!isPalindromeRec("z"))
  assert(isPalindromeRec("amanaplanacanalpanama"))
  assert(!isPalindromeRec("Test 1,2,3"))
  assert(isPalindromeRec("1 2 1"))
  assert(!isPalindromeRec("A man a plan a canal Panama."))

  println("Successfully completed without errors.")
