import Foundation

let fmtDbl = { String(format: "%10.3f", $0) }

Task.detached {
  let formatter = DateFormatter()

  formatter.dateFormat = "yyyy-MM-dd"

  let (data, _) = try await URLSession.shared.bytes(from: URL(fileURLWithPath: CommandLine.arguments[1]))
  var rowStats = [(Date, Double, Int)]()
  var invalidPeriods = 0
  var invalidStart: Date?
  var sumFile = 0.0
  var readings = 0
  var longestInvalid = 0
  var longestInvalidStart: Date?
  var longestInvalidEnd: Date?

  for try await line in data.lines {
    let lineSplit = line.components(separatedBy: "\t")

    guard !lineSplit.isEmpty, let date = formatter.date(from: lineSplit[0]) else {
      fatalError("Invalid date \(lineSplit[0])")
    }

    let data = Array(lineSplit.dropFirst())
    let parsed = stride(from: 0, to: data.endIndex, by: 2).map({idx -> (Double, Int) in
      let slice = data[idx..<idx+2]

      return (Double(slice[idx]) ?? 0, Int(slice[idx+1]) ?? 0)
    })

    var sum = 0.0
    var numValid = 0

    for (val, flag) in parsed {
      if flag <= 0 {
        if invalidStart == nil {
          invalidStart = date
        }

        invalidPeriods += 1
      } else {
        if invalidPeriods > longestInvalid {
          longestInvalid = invalidPeriods
          longestInvalidStart = invalidStart
          longestInvalidEnd = date
        }

        sumFile += val
        sum += val
        numValid += 1
        readings += 1
        invalidPeriods = 0
        invalidStart = nil
      }
    }

    if numValid != 0 {
      rowStats.append((date, sum / Double(numValid), parsed.count - numValid))
    }
  }

  for stat in rowStats.lazy.reversed().prefix(5) {
    print("\(stat.0): Average: \(fmtDbl(stat.1)); Valid Readings: \(24 - stat.2); Invalid Readings: \(stat.2)")
  }

  print("""

        Sum File: \(fmtDbl(sumFile))
        Average: \(fmtDbl(sumFile / Double(readings)))
        Readings: \(readings)
        Longest Invalid: \(longestInvalid) (\(longestInvalidStart!) - \(longestInvalidEnd!))
        """)

  exit(0)
}

dispatchMain()
