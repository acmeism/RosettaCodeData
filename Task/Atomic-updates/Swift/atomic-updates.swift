import Foundation

final class AtomicBuckets: CustomStringConvertible {
  var count: Int {
    return buckets.count
  }

  var description: String {
    return withBucketsLocked { "\(buckets)" }
  }

  var total: Int {
    return withBucketsLocked { buckets.reduce(0, +) }
  }

  private let lock = DispatchSemaphore(value: 1)

  private var buckets: [Int]

  subscript(n: Int) -> Int {
    return withBucketsLocked { buckets[n] }
  }

  init(with buckets: [Int]) {
    self.buckets = buckets
  }

  func transfer(amount: Int, from: Int, to: Int) {
    withBucketsLocked {
      let transferAmount = buckets[from] >= amount ? amount : buckets[from]

      buckets[from] -= transferAmount
      buckets[to] += transferAmount
    }
  }

  private func withBucketsLocked<T>(do: () -> T) -> T {
    let ret: T

    lock.wait()
    ret = `do`()
    lock.signal()

    return ret
  }
}

let bucks = AtomicBuckets(with: [21, 39, 40, 20])
let order = DispatchSource.makeTimerSource()
let chaos = DispatchSource.makeTimerSource()
let printer = DispatchSource.makeTimerSource()

printer.setEventHandler {
  print("\(bucks) = \(bucks.total)")
}

printer.schedule(deadline: .now(), repeating: .seconds(1))
printer.activate()

order.setEventHandler {
  let (b1, b2) = (Int.random(in: 0..<bucks.count), Int.random(in: 0..<bucks.count))
  let (v1, v2) = (bucks[b1], bucks[b2])

  guard v1 != v2 else {
    return
  }

  if v1 > v2 {
    bucks.transfer(amount: (v1 - v2) / 2, from: b1, to: b2)
  } else {
    bucks.transfer(amount: (v2 - v1) / 2, from: b2, to: b1)
  }
}

order.schedule(deadline: .now(), repeating: .milliseconds(5))
order.activate()

chaos.setEventHandler {
  let (b1, b2) = (Int.random(in: 0..<bucks.count), Int.random(in: 0..<bucks.count))

  bucks.transfer(amount: Int.random(in: 0..<(bucks[b1] + 1)), from: b1, to: b2)
}

chaos.schedule(deadline: .now(), repeating: .milliseconds(5))
chaos.activate()

dispatchMain()
