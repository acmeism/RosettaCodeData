#include <gtest/gtest.h>

TEST(PalindromeSuite, Test1)
{
  EXPECT_TRUE(is_palindrome("ada"));
  EXPECT_FALSE(is_palindrome("C++"));

  EXPECT_FALSE(is_palindrome("ada")); // will fail
  EXPECT_TRUE(is_palindrome("C++"));  // will fail
}
