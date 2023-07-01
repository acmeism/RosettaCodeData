require "big"

module Integer
  module Powmod

    # Compute self**e mod m
    def powmod(e, m)
      r, b = 1, self.to_big_i
      while e > 0
        r = (b * r) % m if e.odd?
        b = (b * b) % m
        e >>= 1
      end
      r
    end
  end
end

struct Int; include Integer::Powmod end

a = "2988348162058574136915891421498819466320163312926952423791023078876139".to_big_i
b = "2351399303373464486466122544523690094744975233415544072992656881240319".to_big_i
m = 10.to_big_i ** 40

puts a.powmod(b, m)
