class Apple
  def eat
  end
end

class Carrot
  def eat
  end
end

class FoodBox(T)
  def initialize(@data : Array(T))
    {% if T.union? %}
    {% raise "All items should be eatable" unless T.union_types.all? &.has_method?(:eat) %}
    {% else %}
    {% raise "Items should be eatable" unless T.has_method?(:eat) %}
    {% end %}
  end
end

FoodBox.new([Apple.new, Apple.new])
FoodBox.new([Apple.new, Carrot.new])
FoodBox.new([Apple.new, Carrot.new, 123])
