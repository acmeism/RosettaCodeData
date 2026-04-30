def abelian_sandpile (width, height, stacks)
  pile = Array(Array(Int32)).new(height) { Array(Int32).new(width, 0) }
  minr = maxr = height // 2
  minc = maxc = width // 2
  stacks.each do |(c, r), stack|
    pile[r][c] = stack
    minc = c if c < minc
    maxc = c if c > maxc
    minr = r if r < minr
    maxr = r if r > maxr
  end
  loop do
    done = true
    (minr .. maxr).each do |r|
      (minc .. maxc).each do |c|
        stack = pile[r][c]
        if stack >= 4
          portion = stack // 4
          pile[r][c] %= 4
          (pile[r][c-1] += portion) && (minc = Math.min(minc, c-1))  if c-1 >= 0
          (pile[r][c+1] += portion) && (maxc = Math.max(maxc, c+1))  if c+1 < width
          (pile[r-1][c] += portion) && (minr = Math.min(minr, r-1))  if r-1 >= 0
          (pile[r+1][c] += portion) && (maxr = Math.max(maxr, r+1))  if r+1 < height
          done = false
        end
      end
    end
    break if done
  end
  pile
end

def write_sandpile_to_ppm (name, pile, palette = [0, 0x73AAF9, 0xFFC000, 0x7C0000])
  File.open(name, "w") do |f|
    f.print "P6\n#{pile[0].size} #{pile.size} 255"
    f.write_byte 10
    pile.each do |row|
      row.each do |stack|
        color = palette[stack]
        f.write_byte (color >> 16 & 0xff).to_u8   # red
        f.write_byte (color >>  8 & 0xff).to_u8   # green
        f.write_byte (color       & 0xff).to_u8   # blue
      end
    end
  end
end

def usage
  STDERR.puts "Usage: #$0 filename width height x y stacksize [x y stacksize ...]"
  STDERR.puts "   or: #$0 filename stacksize"
  exit
end

filename = ""
width = height = 0
stacks = [] of { {Int32, Int32}, Int32 }

begin
  filename = ARGV.shift
  if ARGV.size == 1
    stacksize = ARGV.shift.to_i
    size = Math.sqrt(stacksize / 1.75).to_i + 3
    size += 1 unless size.odd?
    height = width = size
    stacks << { { size // 2, size // 2 }, stacksize }
  else
    width, height = ARGV.shift.to_i, ARGV.shift.to_i
    ARGV.each_slice(3) do |slice|
      stacks << { { slice[0].to_i, slice[1].to_i }, slice[2].to_i }
    end
  end
rescue
  usage
end

write_sandpile_to_ppm filename, abelian_sandpile(width, height, stacks)
