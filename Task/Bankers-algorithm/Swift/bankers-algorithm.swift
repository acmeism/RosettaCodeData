import Foundation

print("Enter the number of resources: ", terminator: "")

guard let resources = Int(readLine(strippingNewline: true)!) else {
  fatalError()
}

print("Enter the number of processes: ", terminator: "")

guard let processes = Int(readLine(strippingNewline: true)!) else {
  fatalError()
}

var running = Array(repeating: true, count: processes)
var curr = Array(repeating: [Int](), count: processes)
var alloc = Array(repeating: 0, count: resources)
var available = Array(repeating: 0, count: resources)
var maxClaims = Array(repeating: [Int](), count: processes)
var count = processes

print("Enter the \(resources)-item claim vector: ", terminator: "")

guard let maxRes = readLine(strippingNewline: true)?.components(separatedBy: " ").compactMap(Int.init),
      maxRes.count == resources else {
  fatalError()
}

print("Enter the \(processes)-line \(resources)-column allocated-resource table:")

for i in 0..<processes {
  print("Row \(i + 1): ", terminator: "")

  guard let allc = readLine(strippingNewline: true)?.components(separatedBy: " ").compactMap(Int.init),
        maxRes.count == resources else {
    fatalError()
  }

  curr[i] = allc
}

print("Enter the \(processes)-line \(resources)-column maximum-claim table:")

for i in 0..<processes {
  print("Row \(i + 1): ", terminator: "")

  guard let clms = readLine(strippingNewline: true)?.components(separatedBy: " ").compactMap(Int.init),
        maxRes.count == resources else {
    fatalError()
  }

  maxClaims[i] = clms
}

for i in 0..<processes {
  for j in 0..<resources {
    alloc[j] += curr[i][j]
  }
}

for i in 0..<resources {
  available[i] = maxRes[i] - alloc[i]
}

print("The claim vector is: \(maxRes)")
print("The allocated resources table is: \(curr)")
print("The maximum claims table is: \(maxClaims)")
print("The allocated resources are: \(alloc)")
print("The available resources are: \(available)")

while count != 0 {
  var safe = false

  for i in 0..<processes where running[i] {
    var exec = true

    for j in 0..<resources where maxClaims[i][j] - curr[i][j] > available[j] {
      exec = false
      break
    }

    if exec {
      print("Process \(i + 1) is executing.")
      running[i] = false
      count -= 1
      safe = true

      for j in 0..<resources {
        available[j] += curr[i][j]
      }

      break
    }
  }

  if safe {
    print("The process is in safe state.")
  } else {
    print("The processes are in unsafe state.")
    break
  }

  print("The available vector is: \(available)")
}
