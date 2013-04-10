require 'test/unit'
class EthiopianTests < Test::Unit::TestCase
  def test_iter1; assert_equal(578, ethopian_multiply(17,34)); end
  def test_iter2; assert_equal(100, ethopian_multiply(20,5));  end
  def test_iter3; assert_equal(5,   ethopian_multiply(5,1));   end
  def test_iter4; assert_equal(5,   ethopian_multiply(1,5));   end
  def test_iter5; assert_equal(0,   ethopian_multiply(5,0));   end
  def test_iter6; assert_equal(0,   ethopian_multiply(0,5));   end
  def test_rec1;  assert_equal(578, rec_ethopian_multiply(17,34)); end
  def test_rec2;  assert_equal(100, rec_ethopian_multiply(20,5));  end
  def test_rec3;  assert_equal(5,   rec_ethopian_multiply(5,1));   end
  def test_rec4;  assert_equal(5,   rec_ethopian_multiply(1,5));   end
  def test_rec5;  assert_equal(0,   rec_ethopian_multiply(5,0));   end
  def test_rec6;  assert_equal(0,   rec_ethopian_multiply(0,5));   end
end
