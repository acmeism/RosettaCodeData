X, Y, Z = 6, 2, 3
DIR = {"-" => [1,0], "|" => [0,1], "/" => [1,1]}

def cuboid(nx, ny, nz)
  puts "cuboid %d %d %d:" % [nx, ny, nz]
  x, y, z = X*nx, Y*ny, Z*nz
  area = Array.new(y+z+1){" " * (x+y+1)}
  draw_line = lambda do |n, sx, sy, c|
    dx, dy = DIR[c]
    (n+1).times do |i|
      xi, yi = sx+i*dx, sy+i*dy
      area[yi][xi] = (area[yi][xi]==" " ? c : "+")
    end
  end
  nz    .times {|i| draw_line[x,     0,   Z*i, "-"]}
  (ny+1).times {|i| draw_line[x,   Y*i, z+Y*i, "-"]}
  nx    .times {|i| draw_line[z,   X*i,     0, "|"]}
  (ny+1).times {|i| draw_line[z, x+Y*i,   Y*i, "|"]}
  nz    .times {|i| draw_line[y,     x,   Z*i, "/"]}
  (nx+1).times {|i| draw_line[y,   X*i,     z, "/"]}
  puts area.reverse
end

cuboid(2, 3, 4)
cuboid(1, 1, 1)
cuboid(6, 2, 1)
cuboid(2, 4, 1)
