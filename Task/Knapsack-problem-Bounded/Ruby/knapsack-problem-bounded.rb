# Item struct to represent each item in the problem
Struct.new('Item', :name, :weight, :value, :count)

$items = [
  Struct::Item.new('map', 9, 150, 1),
  Struct::Item.new('compass', 13, 35, 1),
  Struct::Item.new('water', 153, 200, 3),
  Struct::Item.new('sandwich', 50, 60, 2),
  Struct::Item.new('glucose', 15, 60, 2),
  Struct::Item.new('tin', 68, 45, 3),
  Struct::Item.new('banana', 27, 60, 3),
  Struct::Item.new('apple', 39, 40, 3),
  Struct::Item.new('cheese', 23, 30, 1),
  Struct::Item.new('beer', 52, 10, 3),
  Struct::Item.new('suntan cream', 11, 70, 1),
  Struct::Item.new('camera', 32, 30, 1),
  Struct::Item.new('t-shirt', 24, 15, 2),
  Struct::Item.new('trousers', 48, 10, 2),
  Struct::Item.new('umbrella', 73, 40, 1),
  Struct::Item.new('w-trousers', 42, 70, 1),
  Struct::Item.new('w-overcoat', 43, 75, 1),
  Struct::Item.new('note-case', 22, 80, 1),
  Struct::Item.new('sunglasses', 7, 20, 1),
  Struct::Item.new('towel', 18, 12, 2),
  Struct::Item.new('socks', 4, 50, 1),
  Struct::Item.new('book', 30, 10, 2)
]

def choose_item(weight, id, cache)
  return 0, [] if id < 0

  k = [weight, id]
  return cache[k] unless cache[k].nil?
  value = $items[id].value
  best_v = 0
  best_list = []
  ($items[id].count+1).times do |i|
    wlim = weight - i * $items[id].weight
    break if wlim < 0
    val, taken = choose_item(wlim, id - 1, cache)
    if val + i * value > best_v
      best_v = val + i * value
      best_list = taken + [i]
    end
  end
  cache[k] = [best_v, best_list]
  return [best_v, best_list]
end

val, list = choose_item(400, $items.length - 1, {})
w = 0
list.each_with_index do |cnt, i|
  if cnt > 0
    print "#{cnt} #{$items[i].name}\n"
    w += $items[i][1] * cnt
  end
end

p "Total weight: #{w}, Value: #{val}"
