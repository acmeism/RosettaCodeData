SIZE = 100

WHITE = false
BLACK = true

plane = Array.new(SIZE) { Array.new(SIZE, WHITE) }

dirs = [[0, -1], [1, 0], [0, 1], [-1, 0]]

row = col = 50
dir = 0

loop do
  break unless 0 <= row < SIZE && 0 <= col < SIZE
  color = plane[row][col]
  dir = (dir + (color == BLACK ? -1 : 1)) % dirs.size
  dx, dy = dirs[dir]
  plane[row][col] = !color
  row += dy; col += dx
end

# crop
start_row = plane.index!  {|row| row.any? BLACK }
end_row   = plane.rindex! {|row| row.any? BLACK }

# print
plane[start_row..end_row].each do |row|
  puts row.map {|color| color == BLACK ? '#' : ' ' }.join
end
