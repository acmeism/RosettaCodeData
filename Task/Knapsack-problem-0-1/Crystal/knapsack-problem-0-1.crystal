require "bit_array"

struct BitArray
  def clone
    BitArray.new(size).tap { |new| new.to_slice.copy_from (to_slice) }
  end
end

record Item, name : String, weight : Int32, value : Int32

record Selection, mask : BitArray, cur_index : Int32, total_value : Int32

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
    # candidate is a best of available items, so if we fill remaining value with it
    # and still don't reach the threshold, the branch is wrong
    return nil if taken.total_value + 1.0 * candidate.value / candidate.weight * remaining_weight < @threshold_value
    # now recursively check both variants
    mask = taken.mask.clone
    mask[candidate_index] = true
    knapsack_step Selection.new(mask, candidate_index + 1, taken.total_value + candidate.value), items, remaining_weight - candidate.weight
    mask = taken.mask.clone
    mask[candidate_index] = false
    knapsack_step Selection.new(mask, candidate_index + 1, taken.total_value), items, remaining_weight
  end

  def select(items, max_weight)
    @checked_variants = 0
    # sort by descending relative value
    list = items.sort_by { |item| -1.0 * item.value / item.weight }
    # use heuristic of relative value as an initial estimate for branch&bounds
    w = max_weight
    heur_list = list.take_while { |item| w -= item.weight; w > 0 }
    nothing = Selection.new(BitArray.new(items.size), 0, 0)
    @threshold_value = heur_list.sum(&.value) - 1
    @threshold_choice = nothing
    knapsack_step(nothing, list, max_weight)
    selected = @threshold_choice.not_nil!
    result = [] of Item
    selected.mask.each_with_index { |v, i| result << list[i] if v }
    result
  end
end

possible = [
  Item.new("map", 9, 150),
  Item.new("compass", 13, 35),
  Item.new("water", 153, 200),
  Item.new("sandwich", 50, 160),
  Item.new("glucose", 15, 60),
  Item.new("tin", 68, 45),
  Item.new("banana", 27, 60),
  Item.new("apple", 39, 40),
  Item.new("cheese", 23, 30),
  Item.new("beer", 52, 10),
  Item.new("suntan cream", 11, 70),
  Item.new("camera", 32, 30),
  Item.new("T-shirt", 24, 15),
  Item.new("trousers", 48, 10),
  Item.new("umbrella", 73, 40),
  Item.new("waterproof trousers", 42, 70),
  Item.new("waterproof overclothes", 43, 75),
  Item.new("note-case", 22, 80),
  Item.new("sunglasses", 7, 20),
  Item.new("towel", 18, 12),
  Item.new("socks", 4, 50),
  Item.new("book", 30, 10),
]

solver = Knapsack.new
used = solver.select(possible, 400)
puts "optimal choice: #{used.map(&.name)}"
puts "total weight #{used.sum(&.weight)}, total value #{used.sum(&.value)}"
puts "checked nodes: #{solver.checked_nodes}"
