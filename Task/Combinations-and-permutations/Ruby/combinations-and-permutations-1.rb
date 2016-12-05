include Math

class Integer

  def permutation(k)
    (self-k+1 .. self).inject( :*)
  end

  def combination(k)
    self.permutation(k) / (1 .. k).inject( :*)
  end

  def big_permutation(k)
    exp( lgamma_plus(self) - lgamma_plus(self -k))
  end

  def big_combination(k)
    exp( lgamma_plus(self) - lgamma_plus(self - k) - lgamma_plus(k))
  end

  private
  def lgamma_plus(n)
    lgamma(n+1)[0]  #lgamma is the natural log of gamma
  end

end

p 12.permutation(9)               #=> 79833600
p 12.big_permutation(9)           #=> 79833600.00000021
p 60.combination(53)              #=> 386206920
p 145.big_permutation(133)        #=> 1.6801459655817956e+243
p 900.big_combination(450)        #=> 2.247471882064647e+269
p 1000.big_combination(969)       #=> 7.602322407770517e+58
p 15000.big_permutation(73)       #=> 6.004137561717704e+304
#That's about the maximum of Float:
p 15000.big_permutation(74)       #=> Infinity
#Fixnum has no maximum:
p 15000.permutation(74)           #=> 896237613852967826239917238565433149353074416025197784301593335243699358040738127950872384197159884905490054194835376498534786047382445592358843238688903318467070575184552953997615178973027752714539513893159815472948987921587671399790410958903188816684444202526779550201576117111844818124800000000000000000000
