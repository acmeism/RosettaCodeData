enum Track: Int, Hashable {
  case left = -1, straight, right
}

extension Track: Comparable {
  static func < (lhs: Track, rhs: Track) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

func < (lhs: [Track], rhs: [Track]) -> Bool {
  for (l, r) in zip(lhs, rhs) where l != r {
    return l < r
  }

  return false
}

func normalize(_ tracks: [Track]) -> [Track] {
  let count = tracks.count
  var workingTracks = tracks
  var norm = tracks

  for _ in 0..<count {
    if workingTracks < norm {
      norm = workingTracks
    }

    let temp = workingTracks[0]

    for j in 1..<count {
      workingTracks[j - 1] = workingTracks[j]
    }

    workingTracks[count - 1] = temp
  }

  return norm
}

func fullCircleStraight(tracks: [Track], nStraight: Int) -> Bool {
  guard nStraight != 0 else {
    return true
  }

  guard tracks.filter({ $0 == .straight }).count == nStraight else {
    return false
  }

  var straight = [Int](repeating: 0, count: 12)
  var i = 0
  var idx = 0

  while i < tracks.count && idx >= 0 {
    if tracks[i] == .straight {
      straight[idx % 12] += 1
    }

    idx += tracks[i].rawValue
    i += 1
  }

  return !((0...5).contains(where: { straight[$0] != straight[$0 + 6] }) &&
    (0...7).contains(where: { straight[$0] != straight[$0 + 4] })
  )
}

func fullCircleRight(tracks: [Track]) -> Bool {
  guard tracks.map({ $0.rawValue * 30 }).reduce(0, +) % 360 == 0 else {
    return false
  }

  var rightTurns = [Int](repeating: 0, count: 12)
  var i = 0
  var idx = 0

  while i < tracks.count && idx >= 0 {
    if tracks[i] == .right {
      rightTurns[idx % 12] += 1
    }

    idx += tracks[i].rawValue
    i += 1
  }

  return !((0...5).contains(where: { rightTurns[$0] != rightTurns[$0 + 6] }) &&
    (0...7).contains(where: { rightTurns[$0] != rightTurns[$0 + 4] })
  )
}

func circuits(nCurved: Int, nStraight: Int) {
  var solutions = Set<[Track]>()

  for tracks in getPermutationsGen(nCurved: nCurved, nStraight: nStraight)
      where fullCircleStraight(tracks: tracks, nStraight: nStraight) && fullCircleRight(tracks: tracks)  {
    solutions.insert(normalize(tracks))
  }

  report(solutions: solutions, nCurved: nCurved, nStraight: nStraight)
}

func getPermutationsGen(nCurved: Int, nStraight: Int) -> PermutationsGen {
  precondition((nCurved + nStraight - 12) % 4 == 0, "input must be 12 + k * 4")

  let trackTypes: [Track]

  if nStraight == 0 {
    trackTypes = [.right, .left]
  } else if nCurved == 12 {
    trackTypes = [.right, .straight]
  } else {
    trackTypes = [.right, .left, .straight]
  }

  return PermutationsGen(numPositions: nCurved + nStraight, choices: trackTypes)
}

func report(solutions: Set<[Track]>, nCurved: Int, nStraight: Int) {
  print("\(solutions.count) solutions for C\(nCurved),\(nStraight)")

  if nCurved <= 20 {
    for tracks in solutions {
      for track in tracks {
        print(track.rawValue, terminator: " ")
      }

      print()
    }
  }
}

struct PermutationsGen: Sequence, IteratorProtocol {
  private let choices: [Track]
  private var indices: [Int]
  private var sequence: [Track]
  private var carry = 0

  init(numPositions: Int, choices: [Track]) {
    self.choices = choices
    self.indices = .init(repeating: 0, count: numPositions)
    self.sequence = .init(repeating: choices.first!, count: numPositions)
  }

  mutating func next() -> [Track]? {
    guard carry != 1 else {
      return nil
    }

    carry = 1
    var i = 1

    while i < indices.count && carry > 0 {
      indices[i] += carry
      carry = 0

      if indices[i] == choices.count {
        carry = 1
        indices[i] = 0
      }

      i += 1
    }

    for j in 0..<indices.count {
      sequence[j] = choices[indices[j]]
    }

    return sequence
  }
}

for n in stride(from: 12, through: 32, by: 4) {
  circuits(nCurved: n, nStraight: 0)
}

circuits(nCurved: 12, nStraight: 4)
