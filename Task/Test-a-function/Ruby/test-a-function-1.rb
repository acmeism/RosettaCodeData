def palindrome?(s)
  s == s.reverse
end

require 'test/unit'
class MyTests < Test::Unit::TestCase
  def test_palindrome_ok
    assert(palindrome? "aba")
  end

  def test_palindrome_nok
    assert_equal(false, palindrome?("ab"))
  end

  def test_object_without_reverse
    assert_raise(NoMethodError) {palindrome? 42}
  end

  def test_wrong_number_args
    assert_raise(ArgumentError) {palindrome? "a", "b"}
  end

  def test_show_failing_test
    assert(palindrome?("ab"), "this test case fails on purpose")
  end
end
