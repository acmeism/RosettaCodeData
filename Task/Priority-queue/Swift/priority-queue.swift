class Task : Comparable, CustomStringConvertible {
  var priority : Int
  var name: String
  init(priority: Int, name: String) {
    self.priority = priority
    self.name = name
  }
  var description: String {
    return "\(priority), \(name)"
  }
}
func ==(t1: Task, t2: Task) -> Bool {
  return t1.priority == t2.priority
}
func <(t1: Task, t2: Task) -> Bool {
  return t1.priority < t2.priority
}

struct TaskPriorityQueue {
  let heap : CFBinaryHeapRef = {
    var callBacks = CFBinaryHeapCallBacks(version: 0, retain: {
      UnsafePointer(Unmanaged<Task>.fromOpaque(COpaquePointer($1)).retain().toOpaque())
      }, release: {
        Unmanaged<Task>.fromOpaque(COpaquePointer($1)).release()
      }, copyDescription: nil, compare: { (ptr1, ptr2, _) in
        let t1 : Task = Unmanaged<Task>.fromOpaque(COpaquePointer(ptr1)).takeUnretainedValue()
        let t2 : Task = Unmanaged<Task>.fromOpaque(COpaquePointer(ptr2)).takeUnretainedValue()
        return t1 == t2 ? CFComparisonResult.CompareEqualTo : t1 < t2 ? CFComparisonResult.CompareLessThan : CFComparisonResult.CompareGreaterThan
    })
    return CFBinaryHeapCreate(nil, 0, &callBacks, nil)
  }()
  var count : Int { return CFBinaryHeapGetCount(heap) }
  mutating func push(t: Task) {
    CFBinaryHeapAddValue(heap, UnsafePointer(Unmanaged.passUnretained(t).toOpaque()))
  }
  func peek() -> Task {
    return Unmanaged<Task>.fromOpaque(COpaquePointer(CFBinaryHeapGetMinimum(heap))).takeUnretainedValue()
  }
  mutating func pop() -> Task {
    let result = Unmanaged<Task>.fromOpaque(COpaquePointer(CFBinaryHeapGetMinimum(heap))).takeUnretainedValue()
    CFBinaryHeapRemoveMinimumValue(heap)
    return result
  }
}

var pq = TaskPriorityQueue()

pq.push(Task(priority: 3, name: "Clear drains"))
pq.push(Task(priority: 4, name: "Feed cat"))
pq.push(Task(priority: 5, name: "Make tea"))
pq.push(Task(priority: 1, name: "Solve RC tasks"))
pq.push(Task(priority: 2, name: "Tax return"))

while pq.count != 0 {
  print(pq.pop())
}
