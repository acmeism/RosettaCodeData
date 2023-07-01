class Foodbox
  def initialize (*food)
    raise ArgumentError, "food must be eadible" unless  food.all?{|f| f.respond_to?(:eat)}
    @box = food
  end
end

class Fruit
  def eat; end
end

class Apple < Fruit; end

p Foodbox.new(Fruit.new, Apple.new)
# => #<Foodbox:0x00000001420c88 @box=[#<Fruit:0x00000001420cd8>, #<Apple:0x00000001420cb0>]>

p Foodbox.new(Apple.new, "string can't eat")
# => test1.rb:3:in `initialize': food must be eadible (ArgumentError)
