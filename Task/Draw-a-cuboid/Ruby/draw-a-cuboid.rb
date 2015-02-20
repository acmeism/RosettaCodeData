DIR = {"-" => [1,0], "|" => [0,1], "/" => [1,1]}

def cuboid(nx, ny, nz)
  puts "cuboid %d %d %d:" % [nx, ny, nz]
  x, y, z = 8*nx, 2*ny, 4*nz
  area = Array.new(y+z+1){" " * (x+y+1)}
  line = lambda do |n, sx, sy, c|
    dx, dy = DIR[c]
    (n+1).times do |i|
      xi, yi = sx+i*dx, sy+i*dy
      area[yi][xi] = (area[yi][xi]==" " ? c : "+")
    end
  end
  nz    .times {|i| line[x,     0,   4*i, "-"]}
  (ny+1).times {|i| line[x,   2*i, z+2*i, "-"]}
  nx    .times {|i| line[z,   8*i,     0, "|"]}
  (ny+1).times {|i| line[z, x+2*i,   2*i, "|"]}
  nz    .times {|i| line[y,     x,   4*i, "/"]}
  (nx+1).times {|i| line[y,   8*i,     z, "/"]}
  puts area.reverse
end

cuboid(2, 3, 4)
cuboid(1, 1, 1)
cuboid(6, 2, 1)
cuboid(2, 4, 1)
