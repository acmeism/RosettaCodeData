2.1.1 :001 > a = 2**62 -1
 => 4611686018427387903
2.1.1 :002 > a.class
 => Fixnum
2.1.1 :003 > (b = a + 1).class
 => Bignum
2.1.1 :004 > (b-1).class
 => Fixnum
