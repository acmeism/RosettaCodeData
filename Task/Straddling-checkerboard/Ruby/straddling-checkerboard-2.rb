require 'test/unit'
class StraddlingCheckerboardTest < Test::Unit::TestCase
  def setup
    @msg = "One night-it was on the twentieth of March, 1888-I was returning"
    @expected = "ONENIGHTITWASONTHETWENTIETHOFMARCH1888IWASRETURNING"
  end

  def test1
    sc = StraddlingCheckerboard.new "ET AON RISBCDFGHJKLMPQ/UVWXYZ."
    code = sc.encode(@msg)
    plaintext = sc.decode(code)

    puts "using checkerboard: #{sc}"
    puts "original: #{@msg}"
    puts "encoded: #{code}"
    puts "decoded: #{plaintext}"
    assert_equal("450582425181653945125016505180125423293721256216286286288653970163758524", code)
    assert_equal(@expected, plaintext)
  end

  def test_board_with_space_in_first_char
    sc = StraddlingCheckerboard.new " RIOESN ATG./LXYBDKQMJUHWPVCFZ"
    code = sc.encode(@msg)
    plaintext = sc.decode(code)
    #p sc
    #puts "encoded: #{code}"
    #puts "decoded: #{plaintext}"
    assert_equal(@expected, plaintext)
  end

  def test_random_board
    sc = StraddlingCheckerboard.new
    plaintext = sc.decode(sc.encode(@msg))
    assert_equal(@expected, plaintext)
  end

  def test_invalid_input
    assert_raise(ArgumentError) {StraddlingCheckerboard.new "ET ON RISBCDFGHJKLMPQ/UVWXYZ.!"}
  end
end
