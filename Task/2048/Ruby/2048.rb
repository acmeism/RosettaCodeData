#!/usr/bin/ruby

require 'io/console'

class Board
  def initialize size=4, win_limit=2048, cell_width = 6
    @size = size; @cw = cell_width; @win_limit = win_limit
    @board = Array.new(size) {Array.new(size, 0)}
    @moved = true; @score = 0; @no_more_moves = false
    spawn
  end

  def draw
    print "\n\n" if @r_vert
    print '    ' if @r_hori
    print '┌' + (['─' * @cw] * @size).join('┬')  + '┐'
    @board.each do |row|
      print "\n"
      formated = row.map {|num| num == 0 ? ' ' * @cw : format(num)}
      print '    ' if @r_hori
      puts '│' + formated.join('│') + '│'
      print '    ' if @r_hori
      print '├' + ([' '  * @cw] * @size).join('┼') + '┤'
    end
    print "\r"
    print '    ' if @r_hori
    puts '└' + (['─' * @cw] * @size).join('┴')  + '┘'
  end

  def move direction
    case direction
    when :up
      @board = column_map {|c| logic(c)}
      @r_vert = false if $rumble
    when :down
      @board = column_map {|c| logic(c.reverse).reverse}
      @r_vert = true if $rumble
    when :left
      @board = row_map {|r| logic(r)}
      @r_hori = false if $rumble
    when :right
      @board = row_map {|r| logic(r.reverse).reverse}
      @r_hori = true if $rumble
    end
    spawn
    @moved = false
  end

  def print_score
    puts "Your Score is #@score."
    puts "Congratulations, you have won!" if to_enum.any? {|e| e >= @win_limit}
  end

  def no_more_moves?; @no_more_moves; end
  def won?;  to_enum.any? {|e| e >= @win_limit}; end
  def reset!; initialize @size, @win_limit, @cw; end

  private

  def set x, y, val
    @board[y][x] = val
  end

  def spawn
    free_pos = to_enum.select{|elem,x,y| elem == 0}.map{|_,x,y| [x,y]}
    unless free_pos.empty?
      set *free_pos.sample, rand > 0.1 ? 2 : 4 if @moved
    else
      snap = @board
      unless @stop
        @stop = true
        %i{up down left right}.each{|s| move(s)}
        @no_more_moves = true if snap.flatten == @board.flatten
        @board = snap
        @stop = false
      end
    end
  end

  def logic list
    jump = false
    result =
    list.reduce([]) do |res, val|
      if res.last == val && !jump
	res[-1] += val
	@score += val
        jump = true
      elsif val != 0
	res.push val
        jump = false
      end
      res
    end
    result += [0] * (@size - result.length)
    @moved ||= list != result
    result
  end

  def column_map
    xboard = @board.transpose
    xboard.map!{|c| yield c }
    xboard.transpose
  end

  def row_map
    @board.map {|r| yield r }
  end

  def to_enum
    @enum ||= Enumerator.new(@size * @size) do |yielder|
      (@size*@size).times do |i|
	yielder.yield (@board[i / @size][i % @size]), (i % @size), (i / @size )
      end
    end
    @enum.rewind
  end

  def format(num)
    if $color
      cstart = "\e[" + $colors[Math.log(num, 2)] + "m"
      cend = "\e[0m"
    else
      cstart = cend = ""
    end
    cstart + num.to_s.center(@cw) + cend
  end
end

$color = true
$colors = %W{0 1;97 1;93 1;92 1;96 1;91 1;95 1;94 1;30;47 1;43 1;42
1;46 1;41 1;45 1;44 1;33;43 1;33;42 1;33;41 1;33;44}
$rumble = false

$check_score = true
unless ARGV.empty?
  puts "Usage: #$0 [gridsize] [score-threshold] [padwidth] [--no-color] [--rumble]"; exit if %W[-h --help].include?(ARGV[0])
  args = ARGV.map(&:to_i).reject{|n| n == 0}
  b = Board.new(*args) unless args.empty?
  $rumble = true if ARGV.any?{|a| a =~ /rumble/i }
  $color = false if ARGV.any?{|a| a =~ /no.?color/i}
end

b ||= Board.new
puts "\e[H\e[2J"
b.draw
puts "Press h for help, q to quit"
loop do
  input = STDIN.getch
  if input == "\e"
    2.times {input << STDIN.getch}
  end

  case input
  when "\e[A", "w" then b.move(:up)
  when "\e[B", "s" then b.move(:down)
  when "\e[C", "d" then b.move(:right)
  when "\e[D", "a" then b.move(:left)

  when "q","\u0003","\u0004"  then b.print_score; exit

  when "h"
    puts <<-EOM.gsub(/^\s*/, '')
      ┌─                                                                                  ─┐
      │Use the arrow-keys or WASD on your keyboard to push board in the given direction.
      │Tiles with the same number merge into one.
      │Get a tile with a value of #{ARGV[1] || 2048} to win.
      │In case you cannot move or merge any tiles anymore, you loose.
      │You can start this game with different settings by providing commandline argument:
      │For instance:
      │  %> #$0 6 8192 --rumble
      └─                                                                                  ─┘
      PRESS q TO QUIT (or Ctrl-C or Ctrl-D)
    EOM
    input = STDIN.getch
  end

  puts "\e[H\e[2J"
  b.draw

  if b.no_more_moves? or $check_score && b.won?
    b.print_score
    if b.no_more_moves?
      puts "No more moves possible"
      puts "Again? (y/n)"
      exit if STDIN.gets.chomp.downcase == "n"
      $check_score = true
      b.reset!
      puts "\e[H\e[2J"
      b.draw
    else
      puts "Continue? (y/n)"
      exit if STDIN.gets.chomp.downcase == "n"
      $check_score = false
      puts "\e[H\e[2J"
      b.draw
    end
  end
end
