N = 5

def generate_square
  perms  =  (1..N).to_a.permutation(N).to_a.shuffle
  square = []
  N.times do
    square << perms.pop
    perms.reject!{|perm| perm.zip(square.last).any?{|el1, el2| el1 == el2} }
  end
  square
end

def print_square(square)
  cell_size = N.digits.size + 1
  strings = square.map!{|row| row.map!{|el| el.to_s.rjust(cell_size)}.join }
  puts strings, "\n"
end

2.times{print_square( generate_square)}
