KnapsackItem = Struct.new(:name, :weight, :value)
potential_items = [
  KnapsackItem['map', 9, 150],              KnapsackItem['compass', 13, 35],
  KnapsackItem['water', 153, 200],          KnapsackItem['sandwich', 50, 160],
  KnapsackItem['glucose', 15, 60],          KnapsackItem['tin', 68, 45],
  KnapsackItem['banana', 27, 60],           KnapsackItem['apple', 39, 40],
  KnapsackItem['cheese', 23, 30],           KnapsackItem['beer', 52, 10],
  KnapsackItem['suntan cream', 11, 70],     KnapsackItem['camera', 32, 30],
  KnapsackItem['t-shirt', 24, 15],          KnapsackItem['trousers', 48, 10],
  KnapsackItem['umbrella', 73, 40],         KnapsackItem['waterproof trousers', 42, 70],
  KnapsackItem['waterproof overclothes', 43, 75], KnapsackItem['note-case', 22, 80],
  KnapsackItem['sunglasses', 7, 20],        KnapsackItem['towel', 18, 12],
  KnapsackItem['socks', 4, 50],             KnapsackItem['book', 30, 10],
]
knapsack_capacity = 400

class Array
  # do something for each element of the array's power set
  def power_set
    yield [] if block_given?
    self.inject([[]]) do |ps, elem|
      ps.each_with_object([]) do |i,r|
        r << i
        new_subset = i + [elem]
        yield new_subset if block_given?
        r << new_subset
      end
    end
  end
end

maxval, solutions = potential_items.power_set.group_by {|subset|
  weight = subset.inject(0) {|w, elem| w + elem.weight}
  weight>knapsack_capacity ? 0 : subset.inject(0){|v, elem| v + elem.value}
}.max

puts "value: #{maxval}"
solutions.each do |set|
  wt, items = 0, []
  set.each {|elem| wt += elem.weight; items << elem.name}
  puts "weight: #{wt}"
  puts "items: #{items.join(',')}"
end
