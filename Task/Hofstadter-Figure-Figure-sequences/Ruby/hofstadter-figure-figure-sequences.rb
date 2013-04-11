$r = [nil, 1]
$s = [nil, 2]

def buildSeq(n)
  current = [ $r[-1], $s[-1] ].max
  while $r.length <= n || $s.length <= n
    idx = [ $r.length, $s.length ].min - 1
    current += 1
    if current == $r[idx] + $s[idx]
      $r << current
    else
      $s << current
    end
  end
end

def ffr(n)
  buildSeq(n)
  $r[n]
end

def ffs(n)
  buildSeq(n)
  $s[n]
end

require 'set'
require 'test/unit'

class TestHofstadterFigureFigure < Test::Unit::TestCase
  def test_first_ten_R_values
    r10 = 1.upto(10).map {|n| ffr(n)}
    assert_equal(r10, [1, 3, 7, 12, 18, 26, 35, 45, 56, 69])
  end

  def test_40_R_and_960_S_are_1_to_1000
    rs_values = Set.new
    rs_values.merge( 1.upto(40).collect  {|n| ffr(n)} )
    rs_values.merge( 1.upto(960).collect {|n| ffs(n)} )
    assert_equal(rs_values, Set.new( 1..1000 ))
  end
end
