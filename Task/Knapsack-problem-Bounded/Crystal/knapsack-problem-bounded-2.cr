# Item struct to represent each item in the problem
record Item, name : String, weight : Int32, value : Int32, count : Int32

def choose_item(items, weight, id, cache)
  return 0, ([] of Int32) if id < 0

  k = {weight, id}
  cache = cache || {} of Tuple(Int32, Int32) => Tuple(Int32, Array(Int32))
  return cache[k] if cache[k]?
  value = items[id].value
  best_v = 0
  best_list = [] of Int32
  (items[id].count + 1).times do |i|
    wlim = weight - i * items[id].weight
    break if wlim < 0
    val, taken = choose_item(items, wlim, id - 1, cache)
    if val + i * value > best_v
      best_v = val + i * value
      best_list = taken + [i]
    end
  end
  cache[k] = {best_v, best_list}
  return {best_v, best_list}
end

items = [
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

val, list = choose_item(items, 400, items.size - 1, nil)
w = 0
list.each_with_index do |cnt, i|
  if cnt > 0
    print "#{cnt} #{items[i].name}\n"
    w += items[i].weight * cnt
  end
end

p "Total weight: #{w}, Value: #{val}"
