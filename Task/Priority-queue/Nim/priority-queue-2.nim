import HeapQueue

var pq = newHeapQueue[(int, string)]()

pq.push((3, "Clear drains"))
pq.push((4, "Feed cat"))
pq.push((5, "Make tea"))
pq.push((1, "Solve RC tasks"))
pq.push((2, "Tax return"))

while pq.len() > 0:
    echo pq.pop()
