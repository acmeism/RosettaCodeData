void CompileTimeTests()
{
  static_assert(is_palindrome("ada"));
  static_assert(!is_palindrome("C++"));

  static_assert(is_palindrome("C++"));  // fails at compile time
  static_assert(!is_palindrome("ada")); // fails at compile time
}

int main()
{
}
