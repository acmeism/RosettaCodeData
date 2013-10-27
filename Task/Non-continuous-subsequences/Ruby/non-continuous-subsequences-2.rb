class Array
  def continuous?(seq)
    seq.each_cons(2) {|a, b| return false if index(a)+1 != index(b)}
    true
  end
end

p %w(a e i o u).non_continuous_subsequences
