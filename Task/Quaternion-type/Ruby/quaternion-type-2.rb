irb(main):001:0> require 'quaternion'
=> true
irb(main):002:0> q = Quaternion.new(1,2,3,4)
=> Quaternion[1, 2, 3, 4]
irb(main):003:0> q1 = Quaternion.new(2,3,4,5)
=> Quaternion[2, 3, 4, 5]
irb(main):004:0> q2 = Quaternion.new(3,4,5,6)
=> Quaternion[3, 4, 5, 6]
irb(main):005:0> r = 7
=> 7
irb(main):006:0> q.norm
=> 5.477225575051661
irb(main):007:0> q1.norm
=> 7.3484692283495345
irb(main):008:0> q2.norm
=> 9.273618495495704
irb(main):009:0> -q
=> Quaternion[-1, -2, -3, -4]
irb(main):010:0> q.conj
=> Quaternion[1, -2, -3, -4]
irb(main):011:0> q1 + q2
=> Quaternion[5, 7, 9, 11]
irb(main):012:0> q2 + q1
=> Quaternion[5, 7, 9, 11]
irb(main):013:0> q + r
=> Quaternion[8, 2, 3, 4]
irb(main):014:0> r + q
=> Quaternion[8, 2, 3, 4]
irb(main):015:0> q * r
=> Quaternion[7, 14, 21, 28]
irb(main):016:0> r * q
=> Quaternion[7, 14, 21, 28]
irb(main):017:0> q1 * q2
=> Quaternion[-56, 16, 24, 26]
irb(main):018:0> q2 * q1
=> Quaternion[-56, 18, 20, 28]
irb(main):019:0> q1 * q2 != q2 * q1
=> true
