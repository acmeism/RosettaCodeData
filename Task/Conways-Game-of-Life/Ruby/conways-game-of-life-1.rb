def game_of_life(name, size, generations, initial_life=nil)
  board = new_board size
  seed board, size, initial_life
  print_board board, 0, name
  reason = generations.times do |gen|
    new = evolve board, size
    print_board new, gen+1, name
    break :all_dead if barren? new, size
    break :static   if board == new
    board = new
  end
  if    reason == :all_dead then puts "no more life."
  elsif reason == :static   then puts "no movement"
  else puts "specified lifetime ended"
  end
end

def new_board(n)
  Array.new(n) {Array.new(n, 0)}
end

def seed(board, n, points=nil)
  if points.nil?
    # randomly seed board
    srand
    indices = []
    n.times {|x| n.times {|y| indices << [x,y] }}
    indices.shuffle[0,10].each {|x,y| board[y][x] = 1}
  else
    points.each {|x, y| board[y][x] = 1}
  end
end

def evolve(board, n)
  new = new_board n
  n.times {|i| n.times {|j| new[i][j] = fate board, i, j, n}}
  new
end

def fate(board, i, j, n)
  i1 = [0, i-1].max; i2 = [i+1, n-1].min
  j1 = [0, j-1].max; j2 = [j+1, n-1].min
  sum = 0
  for ii in (i1..i2)
    for jj in (j1..j2)
      sum += board[ii][jj] if not (ii == i and jj == j)
    end
  end
  (sum == 3 or (sum == 2 and board[i][j] == 1)) ? 1 : 0
end

def barren?(board, n)
  n.times {|i| n.times {|j| return false if board[i][j] == 1}}
  true
end

def print_board(m, generation, name)
  puts "#{name}: generation #{generation}"
  m.each {|row| row.each {|val| print "#{val == 1 ? '#' : '.'} "}; puts}
  puts
end


game_of_life "blinker", 3, 2, [[1,0],[1,1],[1,2]]
#game_of_life "glider", 4, 4, [[1,0],[2,1],[0,2],[1,2],[2,2]]
#game_of_life "random", 5, 10
