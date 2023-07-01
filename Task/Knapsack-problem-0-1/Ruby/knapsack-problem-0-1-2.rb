KnapsackItem = Struct.new(:name, :weight, :value)

def dynamic_programming_knapsack(items, max_weight)
  num_items = items.size
  cost_matrix = Array.new(num_items){Array.new(max_weight+1, 0)}

  num_items.times do |i|
    (max_weight + 1).times do |j|
      if(items[i].weight > j)
        cost_matrix[i][j] = cost_matrix[i-1][j]
      else
        cost_matrix[i][j] = [cost_matrix[i-1][j], items[i].value + cost_matrix[i-1][j-items[i].weight]].max
      end
    end
  end
  used_items = get_used_items(items, cost_matrix)
  [get_list_of_used_items_names(items, used_items),                     # used items names
   items.zip(used_items).map{|item,used| item.weight*used}.inject(:+),  # total weight
   cost_matrix.last.last]                                               # total value
end

def get_used_items(items, cost_matrix)
  i = cost_matrix.size - 1
  currentCost = cost_matrix[0].size - 1
  marked = cost_matrix.map{0}

  while(i >= 0 && currentCost >= 0)
    if(i == 0 && cost_matrix[i][currentCost] > 0 ) || (cost_matrix[i][currentCost] != cost_matrix[i-1][currentCost])
      marked[i] = 1
      currentCost -= items[i].weight
    end
    i -= 1
  end
  marked
end

def get_list_of_used_items_names(items, used_items)
  items.zip(used_items).map{|item,used| item.name if used>0}.compact.join(', ')
end

if $0 == __FILE__
  items = [
    KnapsackItem['map'                   ,   9, 150], KnapsackItem['compass'            , 13,  35],
    KnapsackItem['water'                 , 153, 200], KnapsackItem['sandwich'           , 50, 160],
    KnapsackItem['glucose'               ,  15,  60], KnapsackItem['tin'                , 68,  45],
    KnapsackItem['banana'                ,  27,  60], KnapsackItem['apple'              , 39,  40],
    KnapsackItem['cheese'                ,  23,  30], KnapsackItem['beer'               , 52,  10],
    KnapsackItem['suntan cream'          ,  11,  70], KnapsackItem['camera'             , 32,  30],
    KnapsackItem['t-shirt'               ,  24,  15], KnapsackItem['trousers'           , 48,  10],
    KnapsackItem['umbrella'              ,  73,  40], KnapsackItem['waterproof trousers', 42,  70],
    KnapsackItem['waterproof overclothes',  43,  75], KnapsackItem['note-case'          , 22,  80],
    KnapsackItem['sunglasses'            ,   7,  20], KnapsackItem['towel'              , 18,  12],
    KnapsackItem['socks'                 ,   4,  50], KnapsackItem['book'               , 30,  10]
  ]

  names, weight, value = dynamic_programming_knapsack(items, 400)
  puts
  puts 'Dynamic Programming:'
  puts
  puts "Found solution: #{names}"
  puts "total weight: #{weight}"
  puts "total value: #{value}"
end
