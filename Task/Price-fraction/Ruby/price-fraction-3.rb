require 'test/unit'

class PriceFractionTests < Test::Unit::TestCase
  @@ok_tests = [
    [0.3793, 0.54],
    [0.4425, 0.58],
    [0.0746, 0.18],
    [0.6918, 0.78],
    [0.2993, 0.44],
    [0.5486, 0.66],
    [0.7848, 0.86],
    [0.9383, 0.98],
    [0.2292, 0.38],
  ]
  @@bad_tests = [1.02, -3]

  def test_ok
    @@ok_tests.each do |val, exp|
      assert_equal(exp, rescale_price_fraction(val))
      assert_equal(exp, Price.new(val).standard_value)
    end
    @@bad_tests.each do |val|
      assert_raise(ArgumentError) {rescale_price_fraction(val)}
      assert_raise(ArgumentError) {Price.new(val).standard_value}
    end
  end
end
