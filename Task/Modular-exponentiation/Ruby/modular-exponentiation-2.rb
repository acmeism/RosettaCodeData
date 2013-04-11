class Integer
  def rosetta_mod_exp(exp, mod)
    exp < 0 and raise ArgumentError, "negative exponent"
    prod = 1
    base = self % mod
    until exp.zero?
      exp.odd? and prod = (prod * base) % mod
      exp >>= 1
      base = (base * base) % mod
    end
    prod
  end
end

a = 2988348162058574136915891421498819466320163312926952423791023078876139
b = 2351399303373464486466122544523690094744975233415544072992656881240319
m = 10 ** 40
puts a.rosetta_mod_exp(b, m)
