require "big"

def powers (power)
  (0.to_big_i..).each.map {|n| n ** power }
end

def filtered (iter1, iter2)
  next_skipped = iter2.next
  iter1.reject { |n|
    while (ns = next_skipped) && ns.is_a?(Number) && n > ns
      next_skipped = iter2.next
    end
    n == next_skipped
  }
end

squares = powers 2
cubes = powers 3

p filtered(squares, cubes).skip(20).first(10).to_a
