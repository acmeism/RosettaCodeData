import "/sort" for Sort, Find
import "/math" for Nums
import "/queue" for PriorityQueue

var lists = [
    [5, 3, 4],
    [3, 4, 1, -8.4, 7.2, 4, 1, 1.2]
]

for (l in lists) {
    // sort and then find median
    var l2 = Sort.merge(l)
    System.print(Nums.median(l2))

    // using a priority queue
    var pq = PriorityQueue.new()
    for (e in l) pq.push(e, -e)
    var c = pq.count
    var v = pq.values
    var m = (c % 2 == 1) ? v[(c/2).floor] : (v[c/2] + v[c/2-1])/2
    System.print(m)

    // using quickselect
    if (c % 2 == 1) {
        System.print(Find.quick(l, (c/2).floor))
    } else {
        var m1 = Find.quick(l, c/2-1)
        var m2 = Find.quick(l, c/2)
        System.print((m1 + m2)/2)
    }
    System.print()
}
