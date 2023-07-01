def nonoblocks(cell, blocks)
  raise 'Those blocks will not fit in those cells' if cell < blocks.inject(0,:+) + blocks.size - 1
  nblock(cell, blocks, '', [])
end

def nblock(cell, blocks, position, result)
  if cell <= 0
    result << position[0..cell-1]
  elsif blocks.empty? or blocks[0].zero?
    result << position + '.' * cell
  else
    rest = cell - blocks.inject(:+) - blocks.size + 2
    bl, *brest = blocks
    rest.times.inject(result) do |res, i|
      nblock(cell-i-bl-1, brest, position + '.'*i + '#'*bl + '.', res)
    end
  end
end

conf = [[ 5, [2, 1]],
        [ 5, []],
        [10, [8]],
        [15, [2, 3, 2, 3]],
        [ 5, [2, 3]],      ]
conf.each do |cell, blocks|
  begin
    puts "#{cell} cells and #{blocks} blocks"
    result = nonoblocks(cell, blocks)
    puts result, result.size, ""
  rescue => e
    p e
  end
end
