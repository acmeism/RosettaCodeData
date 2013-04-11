def primes(limit)
  (enclose = lambda { |primes|
    primes.last.succ.upto(limit) do |trial_pri|
      if primes.find { |pri| (trial_pri % pri).zero? }.nil?
        return enclose.call(primes << trial_pri)
      end
    end
    primes
  }).call([2])
end
