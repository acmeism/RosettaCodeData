class Revolver
  attr_accessor :strategy
  attr_reader :notches, :shot_count

  def initialize(strategy = [:load, :spin, :shoot], num_chambers = 6) # default like Deer hunter
    @chambers = Array.new(num_chambers) # by default 6 nils
    @strategy = strategy
    @notches, @shot_count, @loaded_count = 0, 0, 0
  end

  def load
    raise "gun completely loaded " if @chambers.all? :loaded
    @chambers.rotate! until @chambers[1] == nil #not sure about this; Raku rotates -1
    @chambers[1] = :loaded
    @chambers.rotate! #not sure about this; Raku rotates -1
    @loaded_count += 1
  end

  def spin
    @chambers.rotate!(rand(1..@chambers.size))
  end

  def unload
    @chambers.fill(nil)
    @loaded_count = 0
  end

  def shoot
    @chambers[0] = nil
    @chambers.rotate!
  end

  def play
    strategy.each{|action| send(action)}
    @shot_count += 1
    @notches += 1 unless @chambers.count(:loaded) == @loaded_count # all bullets still there?
    unload
  end
end

strategies = {:A => [:load, :spin, :load, :spin, :shoot, :spin, :shoot],
              :B => [:load, :spin, :load, :spin, :shoot, :shoot],
              :C => [:load, :load, :spin, :shoot, :spin, :shoot],
              :D => [:load, :load, :spin, :shoot, :shoot],
              :E => [:load, :spin, :shoot, :load, :spin, :shoot]}

n = 100_000
puts "simulation of #{n} runs:"
strategies.each do |name, strategy|
  gun = Revolver.new(strategy) # Revolver.new(strategy, 10) for a 10-shooter
  n.times{gun.play}
  puts "Strategy #{name}: #{gun.notches.fdiv(gun.shot_count)}"
end
