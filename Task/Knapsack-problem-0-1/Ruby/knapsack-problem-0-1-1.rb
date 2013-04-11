KnapsackItem = Struct.new(:name, :weight, :value)
potential_items = [
  KnapsackItem.new('map', 9, 150),          KnapsackItem.new('compass', 13, 35),
  KnapsackItem.new('water', 153, 200),      KnapsackItem.new('sandwich', 50, 160),
  KnapsackItem.new('glucose', 15, 60),      KnapsackItem.new('tin', 68, 45),
  KnapsackItem.new('banana', 27, 60),       KnapsackItem.new('apple', 39, 40),
  KnapsackItem.new('cheese', 23, 30),       KnapsackItem.new('beer', 52, 10),
  KnapsackItem.new('suntan cream', 11, 70), KnapsackItem.new('camera', 32, 30),
  KnapsackItem.new('t-shirt', 24, 15),      KnapsackItem.new('trousers', 48, 10),
  KnapsackItem.new('umbrella', 73, 40),     KnapsackItem.new('waterproof trousers', 42, 70),
  KnapsackItem.new('waterproof overclothes', 43, 75), KnapsackItem.new('note-case', 22, 80),
  KnapsackItem.new('sunglasses', 7, 20),    KnapsackItem.new('towel', 18, 12),
  KnapsackItem.new('socks', 4, 50),         KnapsackItem.new('book', 30, 10),
]
knapsack_capacity = 400

class Array
  # do something for each element of the array's power set
  def power_set
    yield [] if block_given?
    self.inject([[]]) do |ps, elem|
      r = []
      ps.each do |i|
        r << i
        new_subset = i + [elem]
        yield new_subset if block_given?
        r << new_subset
      end
      r
    end
  end
end

maxval = 0
solutions = []

potential_items.power_set do |subset|
  weight = subset.inject(0) {|w, elem| w += elem.weight}
  next if weight > knapsack_capacity

  value = subset.inject(0) {|v, elem| v += elem.value}
  if value == maxval
    solutions << subset
  elsif value > maxval
    maxval = value
    solutions = [subset]
  end
end

puts "value: #{maxval}"
solutions.each do |set|
  items = []
  wt = 0
  set.each {|elem| wt += elem.weight; items << elem.name}
  puts "weight: #{wt}"
  puts "items: #{items.sort.join(',')}"
end
