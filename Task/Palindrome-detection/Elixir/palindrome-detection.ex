defmodule PalindromeDetection do
  def is_palindrome(str), do: str == String.reverse(str)
end
