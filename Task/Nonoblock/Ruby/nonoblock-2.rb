class NonoBlock
  def initialize(cell, blocks)
    raise 'Those blocks will not fit in those cells' if cell < blocks.inject(0,:+) + blocks.size - 1
    @result = []
    nonoblocks(cell, blocks, '')
  end

  def result(correct=true)
    correct ? @result.map(&:nonocell) : @result
  end

  private
  def nonoblocks(cell, blocks, position)
    if cell <= 0
      @result << position[0..cell-1]
    elsif blocks.empty? or blocks[0].zero?
      @result << position + '.' * cell
    else
      rest = cell - blocks.inject(0,:+) - blocks.size + 2
      bl, *brest = blocks
      rest.times do |i|
        nonoblocks(cell-i-bl-1, brest, position + '.'*i + '#'*bl + '.')
      end
    end
  end
end

class String
  def nonocell                  # "##.###..##" -> "|A|A|_|B|B|B|_|_|C|C|"
    chr = ('A'..'Z').each
    s = tr('.','_').gsub(/#+/){|sharp| chr.next * sharp.size}
    "|#{s.chars.join('|')}|"
  end
end

if __FILE__ == $0
  conf = [[ 5, [2, 1]],
          [ 5, []],
          [10, [8]],
          [15, [2, 3, 2, 3]],
          [ 5, [2, 3]]       ]
  conf.each do |cell, blocks|
    begin
      puts "Configuration:",
           "#{('.'*cell).nonocell} # #{cell} cells and #{blocks} blocks",
           "Possibilities:"
      result = NonoBlock.new(cell, blocks).result
      puts result,
           "A total of #{result.size} Possible configurations.", ""
    rescue => e
      p e
    end
  end
end
