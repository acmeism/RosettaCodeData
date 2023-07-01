ARRS = [("a".."z").to_a,
        ("A".."Z").to_a,
        ("0".."9").to_a,
        %q(!"#$%&'()*+,-./:;<=>?@[]^_{|}~).chars] # " quote to reset clumsy code colorizer
ALL  = ARRS.flatten

def generate_pwd(size, num)
  raise ArgumentError, "Desired size too small" unless size >= ARRS.size
  num.times.map do
    arr = ARRS.map(&:sample)
    (size - ARRS.size).times{ arr << ALL.sample}
    arr.shuffle.join
  end
end

puts generate_pwd(8,3)
