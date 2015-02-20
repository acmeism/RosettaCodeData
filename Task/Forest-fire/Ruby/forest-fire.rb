class Forest_Fire
  Neighborhood = [-1,0,1].product([-1,0,1]) - [0,0]
  States = {empty:" ", tree:"T", fire:"#"}

  def initialize(xsize, ysize=xsize, p=0.5, f=0.01)
    @xsize, @ysize, @p, @f = xsize, ysize, p, f
    @field = Array.new(xsize+1) {|i| Array.new(ysize+1, :empty)}
    @generation = 0
  end

  def evolve
    @generation += 1
    work = @field.map{|row| row.map{|cell| cell}}
    for i in 0...@xsize
      for j in 0...@ysize
        case cell=@field[i][j]
        when :empty
          cell = :tree  if rand < @p
        when :tree
          cell = :fire  if fire?(i,j)
        else
          cell = :empty
        end
        work[i][j] = cell
      end
    end
    @field = work
  end

  def fire?(i,j)
    rand < @f or Neighborhood.any? {|di,dj| @field[i+di][j+dj] == :fire}
  end

  def display
    puts "Generation : #@generation"
    puts @xsize.times.map{|i| @ysize.times.map{|j| States[@field[i][j]]}.join}
  end
end

forest = Forest_Fire.new(10,30)
10.times do |i|
  forest.evolve
  forest.display
end
