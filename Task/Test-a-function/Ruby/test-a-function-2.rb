# palindrome.rb
def palindrome?(s)
  s == s.reverse
end

require 'minitest/spec'
require 'minitest/autorun'
describe "palindrome? function" do
  it "returns true if arg is a palindrome" do
    (palindrome? "aba").must_equal true
  end

  it "returns false if arg is not a palindrome" do
    palindrome?("ab").must_equal false
  end

  it "raises NoMethodError if arg is without #reverse" do
    proc { palindrome? 42 }.must_raise NoMethodError
  end

  it "raises ArgumentError if wrong number of args" do
    proc { palindrome? "a", "b" }.must_raise ArgumentError
  end

  it "passes a failing test" do
    palindrome?("ab").must_equal true, "this test case fails on purpose"
  end
end
