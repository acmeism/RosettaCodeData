require 'rref'

pyramid = [
           [ 151],
          [nil,nil],
        [40,nil,nil],
      [nil,nil,nil,nil],
    ["x", 11,"y", 4,"z"]
]
pyramid.each{|row| p row}

equations = [[1,-1,1,0]]   # y = x + z

def parse_equation(str)
  eqn = [0] * 4
  lhs, rhs = str.split("=")
  eqn[3] = rhs.to_i
  for term in lhs.split("+")
    case term
    when "x" then eqn[0] += 1
    when "y" then eqn[1] += 1
    when "z" then eqn[2] += 1
    else          eqn[3] -= term.to_i
    end
  end
  eqn
end

-2.downto(-5) do |row|
  pyramid[row].each_index do |col|
    val = pyramid[row][col]
    sum = "%s+%s" % [pyramid[row+1][col], pyramid[row+1][col+1]]
    if val.nil?
      pyramid[row][col] = sum
    else
      equations << parse_equation(sum + "=#{val}")
    end
  end
end

reduced = convert_to(reduced_row_echelon_form(equations), :to_i)

for eqn in reduced
  if eqn[0] + eqn[1] + eqn[2] != 1
    fail "no unique solution! #{equations.inspect} ==> #{reduced.inspect}"
  elsif eqn[0] == 1 then x = eqn[3]
  elsif eqn[1] == 1 then y = eqn[3]
  elsif eqn[2] == 1 then z = eqn[3]
  end
end

puts
puts "x == #{x}"
puts "y == #{y}"
puts "z == #{z}"

answer = []
for row in pyramid
  answer << row.collect {|cell| eval cell.to_s}
end
puts
answer.each{|row| p row}
