require 'prime'

def spiral_generator(x=0, y=0)
  Enumerator.new do |yielder|
    yielder << [x, y]                           # start position
    dx, dy = 0, 1                               # first direction
    yielder << [x+=dx, y+=dy]                   # second position
    0.step do |i|
      2.times do
        i.times{ yielder << [x+=dx, y+=dy] }    # going straight
        dx, dy = -dy, dx                        # 90 degree turn
        yielder << [x+=dx, y+=dy]
      end
    end
  end
end

def ulam_spiral(n, start=1)
  h = Hash.new(0)
  position = spiral_generator
  (start ... start+n*n).each do |i|
    pos = position.next
    h[pos] = 1  if i.prime?
  end

  chr = [[' ', '▄'], ['▀', '█']]
  (xmin, xmax), (ymin, ymax) = h.keys.transpose.map(&:minmax)
  (xmin..xmax).step(2).each do |x|
    puts (ymin..ymax).map{|y| chr[h[[x,y]]][h[[x+1,y]]]}.join
  end
end

[11, 122].each do |n|
  puts "\nN : #{n}"
  ulam_spiral(n)
end
