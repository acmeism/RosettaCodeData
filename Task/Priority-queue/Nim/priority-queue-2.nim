import tables

var
  pq = initTable[int, string]()

proc main() =
  pq.add(3, "Clear drains")
  pq.add(4, "Feed cat")
  pq.add(5, "Make tea")
  pq.add(1, "Solve RC tasks")
  pq.add(2, "Tax return")

  for i in countUp(1,5):
    if pq.hasKey(i):
      echo i, ": ", pq[i]
      pq.del(i)

main()
