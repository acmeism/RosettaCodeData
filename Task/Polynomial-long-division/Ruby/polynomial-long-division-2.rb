def polynomial_division(f, g)
  if g.length == 0 or (g.length == 1 and g[0] == 0)
    raise ArgumentError, "denominator is zero"
  elsif g.length == 1
    [f.collect {|x| Float(x)/g[0]}, [0]]
  elsif g.length == 2
    synthetic_division(f, g)
  else
    higher_degree_synthetic_division(f, g)
  end
end

def synthetic_division(f, g)
  board = [f] << Array.new(f.length) << Array.new(f.length)
  board[2][0] = board[0][0]

  1.upto(f.length - 1).each do |i|
    board[1][i] = board[2][i-1] * -g[1]
    board[2][i] = board[0][i] + board[1][i]
  end

  [board[2][0..-2], [board[2][-1]]]
end

# an ugly mess of array index arithmetic
# http://en.wikipedia.org/wiki/Polynomial_long_division#Higher_degree_synthetic_division
def higher_degree_synthetic_division(f, g)

  # [use] the negative coefficients of the denominator following the leading term
  lhs = g[1..-1].collect {|x| -x}
  board = [f]

  q = []
  1.upto(f.length - lhs.length).each do |i|
    n = 2*i - 1

    # underline the leading coefficient of the right-hand side, multiply it by
    # the left-hand coefficients and write the products beneath the next columns
    # on the right.
    q << board[n-1][i-1]
    board << Array.new(f.length).fill(0, i) # row n
    (lhs.length).times do |j|
      board[n][i+j] = q[-1]*lhs[j]
    end

    # perform an addition
    board << Array.new(f.length).fill(0, i) # row n+1
    (lhs.length + 1).times do |j|
      board[n+1][i+j] = board[n-1][i+j] + board[n][i+j] if i+j < f.length
    end
  end

  # the remaining numbers in the bottom row correspond to the coefficients of the remainder
  r = board[-1].compact
  q = [0] if q.empty?
  [q, r]
end

f = [1, -12, 0, -42]
g = [1, -3]
q, r = polynomial_division(f, g)
puts "#{f} / #{g} => #{q} remainder #{r}"
# => [1, -12, 0, -42] / [1, -3] => [1, -9, -27] remainder [-123]

g = [1, 1, -3]
q, r = polynomial_division(f, g)
puts "#{f} / #{g} => #{q} remainder #{r}"
# => [1, -12, 0, -42] / [1, 1, -3] => [1, -13] remainder [16, -81]
