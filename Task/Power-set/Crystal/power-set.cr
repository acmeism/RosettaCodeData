struct Set
  def powerset
    result = Set(typeof(self)).new
    arr = to_a
    (0..size).each do |n|
      arr.each_combination(n, true) do |comb|
        result << comb.to_set
      end
    end
    result
  end
end

p [1, 2, 3, 4].to_set.powerset
