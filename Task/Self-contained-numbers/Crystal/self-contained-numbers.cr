require "big"

struct Int
  def self_contained?
    return false unless odd?
    n = self.to_big_i
    while n > 1
      n = n.odd? ? n * 3 + 1 : n // 2
      return true if n % self == 0
    end
    false
  end
end

puts (3..).each.select(&.self_contained?).first(7).to_a
