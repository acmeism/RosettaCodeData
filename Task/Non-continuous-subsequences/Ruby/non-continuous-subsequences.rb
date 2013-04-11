class Array
  def func_power_set
    inject([[]]) { |ps,item|    # for each item in the Array
      ps +                      # take the powerset up to now and add
      ps.map { |e| e + [item] } # it again, with the item appended to each element
    }
  end

  def non_continuous_subsequences
    func_power_set.find_all {|seq| not seq.continuous}
  end

  def continuous
    each_cons(2) {|a, b| return false if a+1 != b}
    true
  end
end

p (1..3).to_a.non_continuous_subsequences
p (1..4).to_a.non_continuous_subsequences
p (1..5).to_a.non_continuous_subsequences
