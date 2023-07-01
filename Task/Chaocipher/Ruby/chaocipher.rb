txt    = "WELLDONEISBETTERTHANWELLSAID"
@left  = "HXUCZVAMDSLKPEFJRIGTWOBNYQ".chars
@right = "PTLNBQDEOYSFAVZKGJRIHWXUMC".chars

def encrypt(char)
  coded_char = @left[@right.index(char)]

  @left.rotate!(@left.index(coded_char))
  part = @left.slice!(1,13).rotate
  @left.insert(1, *part)

  @right.rotate!(@right.index(char)+1)
  part = @right.slice!(2,12).rotate
  @right.insert(2, *part)

  @left[0]
end

puts txt.each_char.map{|c| encrypt(c) }.join
