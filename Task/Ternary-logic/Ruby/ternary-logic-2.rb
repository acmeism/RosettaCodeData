$ irb
irb(main):001:0> require './trit'
=> true
irb(main):002:0> maybe = MAYBE
=> maybe
irb(main):003:0> !true.trit
=> false
irb(main):004:0> !maybe.trit
=> maybe
irb(main):005:0> maybe.trit & false
=> false
irb(main):006:0> maybe.trit | true
=> true
irb(main):007:0> false.trit == true
=> false
irb(main):008:0> false.trit == maybe
=> maybe
