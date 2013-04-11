require 'rational'

# returns an 2-D array where each element is a Rational
def reduced_row_echelon_form(ary)
  lead = 0
  rows = ary.size
  cols = ary[0].size
  rary = convert_to_rational(ary)  # use rational arithmetic
  catch :done  do
    rows.times do |r|
      throw :done  if cols <= lead
      i = r
      while rary[i][lead] == 0
        i += 1
        if rows == i
          i = r
          lead += 1
          throw :done  if cols == lead
        end
      end
      # swap rows i and r
      rary[i], rary[r] = rary[r], rary[i]
      # normalize row r
      v = rary[r][lead]
      rary[r].collect! {|x| x /= v}
      # reduce other rows
      rows.times do |i|
        next if i == r
        v = rary[i][lead]
        rary[i].each_index {|j| rary[i][j] -= v * rary[r][j]}
      end
      lead += 1
    end
  end
  rary
end

def convert_to_rational(ary)
  new = []
  ary.each_index do |row|
    new << ary[row].collect {|elem| Rational(elem)}
  end
  new
end

# type should be one of :to_s, :to_i, :to_f, :to_r
def convert_to(ary, type)
  new = []
  ary.each_index do |row|
    new << ary[row].collect {|elem| elem.send(type)}
  end
  new
end

def print_matrix(m)
  max = m[0].collect {-1}
  m.each {|row| row.each_index {|i| max[i] = [max[i], row[i].to_s.length].max}}
  m.each {|row| row.each_index {|i| print "%#{max[i]}s " % row[i].to_s}; puts ""}
end

mtx = [
  [ 1, 2, -1, -4],
  [ 2, 3, -1,-11],
  [-2, 0, -3, 22]
]
print_matrix convert_to(reduced_row_echelon_form(mtx), :to_s)
puts ""

mtx = [
  [ 1, 2, 3, 7],
  [-4, 7,-2, 7],
  [ 3, 3, 0, 7]
]
reduced = reduced_row_echelon_form(mtx)
print_matrix convert_to(reduced, :to_r)
print_matrix convert_to(reduced, :to_f)
