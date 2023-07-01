require 'set'

tests = [[[:A,:B], [:C,:D]],
         [[:A,:B], [:B,:D]],
         [[:A,:B], [:C,:D], [:D,:B]],
         [[:H,:I,:K], [:A,:B], [:C,:D], [:D,:B], [:F,:G,:H]]]
tests.map!{|sets| sets.map(&:to_set)}

tests.each do |sets|
  until sets.combination(2).none?{|a,b| a.merge(b) && sets.delete(b) if a.intersect?(b)}
  end
  p sets
end
