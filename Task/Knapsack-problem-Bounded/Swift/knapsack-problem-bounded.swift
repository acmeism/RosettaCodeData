public struct KnapsackItem: Hashable {
  public var name: String
  public var weight: Int
  public var value: Int

  public init(name: String, weight: Int, value: Int) {
    self.name = name
    self.weight = weight
    self.value = value
  }
}

public func knapsack(items: [KnapsackItem], limit: Int) -> [KnapsackItem] {
  var table = Array(repeating: Array(repeating: 0, count: limit + 1), count: items.count + 1)

  for j in 1...items.count {
    let item = items[j-1]

    for w in 1...limit {
      if item.weight > w {
        table[j][w] = table[j-1][w]
      } else {
        table[j][w] = max(table[j-1][w], table[j-1][w-item.weight] + item.value)
      }
    }
  }

  var result = [KnapsackItem]()
  var w = limit

  for j in stride(from: items.count, to: 0, by: -1) where table[j][w] != table[j-1][w] {
    let item = items[j-1]

    result.append(item)

    w -= item.weight
  }

  return result
}

typealias GroupedItem = (name: String, weight: Int, val: Int, n: Int)

let groupedItems: [GroupedItem] = [
  ("map", 9, 150, 1),
  ("compass", 13, 35, 1),
  ("water", 153, 200, 3),
  ("sandwich", 50, 60, 2),
  ("glucose", 15, 60, 2),
  ("tin", 68, 45, 3),
  ("banana", 27, 60, 3),
  ("apple", 39, 40, 3),
  ("cheese", 23, 30, 1),
  ("beer", 52, 10, 3),
  ("suntan cream", 11, 70, 1),
  ("camera", 32, 30, 1),
  ("t-shirt", 24, 15, 2),
  ("trousers", 48, 10, 2),
  ("umbrella", 73, 40, 1),
  ("waterproof trousers", 42, 70, 1),
  ("waterproof overclothes", 43, 75, 1),
  ("note-case", 22, 80, 1),
  ("sunglasses", 7, 20, 1),
  ("towel", 18, 12, 2),
  ("socks", 4, 50, 1),
  ("book", 30, 10, 2)
]

let items = groupedItems.flatMap({item in
  (0..<item.n).map({_ in KnapsackItem(name: item.name, weight: item.weight, value: item.val) })
})

let bagged = knapsack(items: items, limit: 400)
let (totalVal, totalWeight) = bagged.reduce((0, 0), {cur, item in (cur.0 + item.value, cur.1 + item.weight) })

print("Bagged the following \(bagged.count) items:")

for item in bagged {
  print("\t\(item.name)")
}

print("For a total value of \(totalVal) and weight of \(totalWeight)")
