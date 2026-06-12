import Foundation

class Program {
    private static var dict: [Int: Int] = [:]
    private static var criticalValue = 1
    private static let lockObject = NSLock()
    private static let dictQueue = DispatchQueue(label: "dictQueue", attributes: .concurrent)

    static func main() {
        testSzymanski(n: 20)
    }

    static func flag(_ id: Int) -> Int {
        return dictQueue.sync {
            return dict[id] ?? 0
        }
    }

    static func yield() {
        // Sleep for a short time to yield control
        Thread.sleep(forTimeInterval: 0.001)
    }

    static func runSzymanski(id: Int, allszy: [Int]) {
        let others = allszy.filter { $0 != id }

        dictQueue.async(flags: .barrier) {
            dict[id] = 1 // Standing outside waiting room
        }

        while others.contains(where: { flag($0) >= 3 }) {
            yield()
        }

        dictQueue.async(flags: .barrier) {
            dict[id] = 3 // Standing in doorway
        }

        if others.contains(where: { flag($0) == 1 }) {
            dictQueue.async(flags: .barrier) {
                dict[id] = 2 // Waiting for other processes to enter
            }

            while !others.contains(where: { flag($0) == 4 }) {
                yield()
            }
        }

        dictQueue.async(flags: .barrier) {
            dict[id] = 4 // The door is closed
        }

        for t in others {
            if t >= id { continue }
            while flag(t) > 1 {
                yield()
            }
        }

        // critical section
        lockObject.lock()
        defer { lockObject.unlock() }

        criticalValue += id * 3
        criticalValue /= 2
        print("Thread \(id) changed the critical value to \(criticalValue).")
        // end critical section

        // Exit protocol
        for t in others {
            if t <= id { continue }
            while ![0, 1, 4].contains(flag(t)) {
                yield()
            }
        }

        dictQueue.async(flags: .barrier) {
            dict[id] = 0 // Leave. Reopen door if nobody is still in the waiting room
        }
    }

    static func testSzymanski(n: Int) {
        let allszy = Array(1...n)
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = n

        let operations = allszy.map { i in
            return BlockOperation {
                runSzymanski(id: i, allszy: allszy)
            }
        }

        queue.addOperations(operations, waitUntilFinished: true)
    }
}

// Run the program
Program.main()
