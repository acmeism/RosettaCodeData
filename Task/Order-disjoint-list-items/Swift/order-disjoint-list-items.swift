func disjointOrder<T: Hashable>(m: [T], n: [T]) -> [T] {
  let replaceCounts = n.reduce(into: [T: Int](), { $0[$1, default: 0] += 1 })
  let reduced = m.reduce(into: ([T](), n, replaceCounts), {cur, el in
    cur.0.append(cur.2[el, default: 0] > 0 ? cur.1.removeFirst() : el)
    cur.2[el]? -= 1
  })

  return reduced.0
}

print(disjointOrder(m: ["the", "cat", "sat", "on", "the", "mat"], n: ["mat", "cat"]))
print(disjointOrder(m: ["the", "cat", "sat", "on", "the", "mat"], n: ["cat", "mat"]))
print(disjointOrder(m: ["A", "B", "C", "A", "B", "C", "A", "B", "C"], n: ["C", "A", "C", "A"]))
print(disjointOrder(m: ["A", "B", "C", "A", "B", "D", "A", "B", "E"], n: ["E", "A", "D", "A"]))
print(disjointOrder(m: ["A", "B"], n: ["B"]))
print(disjointOrder(m: ["A", "B"], n: ["B", "A"]))
print(disjointOrder(m: ["A", "B", "B", "A"], n: ["B", "A"]))
