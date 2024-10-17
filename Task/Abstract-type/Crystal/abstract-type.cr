abstract class Animal # only abstract class can have abstract methods
  abstract def move
  abstract def think

  # abstract class can have normal fields and methods
  def initialize(@name : String)
  end

  def process
    think
    move
  end
end

# WalkingAnimal still have to be declared abstract because `think` was not implemented
abstract class WalkingAnimal < Animal
  def move
    puts "#{@name} walks"
  end
end

class Human < WalkingAnimal
  property in_car = false

  def move
    if in_car
      puts "#{@name} drives a car"
    else
      super
    end
  end

  def think
    puts "#{@name} thinks"
  end
end

# Animal.new # => can't instantiate abstract class
he = Human.new("Andrew") # ok
he.process
