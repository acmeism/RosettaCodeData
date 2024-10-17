record Item, name : String, weight : Int32, value : Int32, count : Int32

record Selection, mask : Array(Int32), cur_index : Int32, total_value : Int32

class Knapsack
  @threshold_value = 0
  @threshold_choice : Selection?
  getter checked_nodes = 0

  def knapsack_step(taken, items, remaining_weight)
    if taken.total_value > @threshold_value
      @threshold_value = taken.total_value
      @threshold_choice = taken
    end
    candidate_index = items.index(taken.cur_index) { |item| item.weight <= remaining_weight }
    return nil unless candidate_index
    @checked_nodes += 1
    candidate = items[candidate_index]
    # candidate is a best of available items, so if we fill remaining value with
    # and still don't reach the threshold, the branch is wrong
    return nil if taken.total_value + 1.0 * candidate.value / candidate.weight * remaining_weight < @threshold_value
    # now recursively check all variants (from taking maximum count to taking nothing)
    max_count = {candidate.count, remaining_weight // candidate.weight}.min
    (0..max_count).reverse_each do |n|
      mask = taken.mask.clone
      mask[candidate_index] = n
      knapsack_step Selection.new(mask, candidate_index + 1, taken.total_value + n*candidate.value), items, remaining_weight - n*candidate.weight
    end
  end

  def select(items, max_weight)
    @checked_variants = 0
    # sort by descending relative value
    list = items.sort_by { |item| -1.0 * item.value / item.weight }
    nothing = Selection.new(Array(Int32).new(items.size, 0), 0, 0)
    @threshold_value = 0
    @threshold_choice = nothing
    knapsack_step(nothing, list, max_weight)
    selected = @threshold_choice.not_nil!
    result = Hash(Item, Int32).new(0)
    selected.mask.each_with_index { |v, i| result[list[i]] = v if v > 0 }
    result
  end
end

possible = [
  Item.new("map", 9, 150, 1),
  Item.new("compass", 13, 35, 1),
  Item.new("water", 153, 200, 2),
  Item.new("sandwich", 50, 60, 2),
  Item.new("glucose", 15, 60, 2),
  Item.new("tin", 68, 45, 3),
  Item.new("banana", 27, 60, 3),
  Item.new("apple", 39, 40, 3),
  Item.new("cheese", 23, 30, 1),
  Item.new("beer", 52, 10, 3),
  Item.new("suntan cream", 11, 70, 1),
  Item.new("camera", 32, 30, 1),
  Item.new("T-shirt", 24, 15, 2),
  Item.new("trousers", 48, 10, 2),
  Item.new("umbrella", 73, 40, 1),
  Item.new("waterproof trousers", 42, 70, 1),
  Item.new("waterproof overclothes", 43, 75, 1),
  Item.new("note-case", 22, 80, 1),
  Item.new("sunglasses", 7, 20, 1),
  Item.new("towel", 18, 12, 2),
  Item.new("socks", 4, 50, 1),
  Item.new("book", 30, 10, 2),
]

solver = Knapsack.new
used = solver.select(possible, 400)
puts "optimal choice: #{used.map { |item, count| count == 1 ? item.name : "#{count}x #{item.name}" }.join(", ")}"
puts "total weight #{used.sum { |item, count| item.weight*count }}"
puts "total value #{used.sum { |item, count| item.value*count }}"
puts "checked nodes: #{solver.checked_nodes}"
