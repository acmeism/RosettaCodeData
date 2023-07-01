require "spec"

describe "palindrome" do
  it "returns true for a word that's palindromic" do
    palindrome("racecar").should be_true
  end

  it "returns false for a word that's not palindromic" do
    palindrome("goodbye").should be_false
  end
end

def palindrome(s)
  s == s.reverse
end
