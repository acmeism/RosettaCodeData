import Foundation

public struct Vector {
  public var px = 0.0
  public var py = 0.0
  public var pz = 0.0

  public init(px: Double, py: Double, pz: Double) {
    (self.px, self.py, self.pz) = (px, py, pz)
  }

  public init?(array: [Double]) {
    guard array.count == 3 else {
      return nil
    }

    (self.px, self.py, self.pz) = (array[0], array[1], array[2])
  }

  public func mod() -> Double {
    (px * px + py * py + pz * pz).squareRoot()
  }

  static func + (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(
      px: lhs.px + rhs.px,
      py: lhs.py + rhs.py,
      pz: lhs.pz + rhs.pz
    )
  }

  static func - (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(
      px: lhs.px - rhs.px,
      py: lhs.py - rhs.py,
      pz: lhs.pz - rhs.pz
    )
  }

  static func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(
      px: lhs.px * rhs,
      py: lhs.py * rhs,
      pz: lhs.pz * rhs
    )
  }
}

extension Vector {
  public static let origin = Vector(px: 0, py: 0, pz: 0)
}

extension Vector: Equatable {
  public static func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.px == rhs.px && lhs.py == rhs.py && lhs.pz == rhs.pz
  }
}

extension Vector: CustomStringConvertible {
  public var description: String {
    return String(format: "%.6f\t%.6f\t%.6f", px, py, pz)
  }
}

public class NBody {
  public let gravitationalConstant: Double
  public let numBodies: Int
  public let timeSteps: Int

  public private(set) var masses: [Double]
  public private(set) var positions: [Vector]
  public private(set) var velocities: [Vector]
  public private(set) var accelerations: [Vector]

  public init?(file: String) {
    guard let data = try? String(contentsOfFile: file) else {
      return nil
    }

    print("Input file:\n\(data)")

    let lines = data.components(separatedBy: "\n").map({ $0.components(separatedBy: " ") })

    let worldData = lines.first!

    guard worldData.count == 3,
          let gc = Double(worldData[0]),
          let bodies = Int(worldData[1]),
          let timeSteps = Int(worldData[2]) else {
      return nil
    }

    let defaultState = Array(repeating: Vector.origin, count: bodies)

    self.gravitationalConstant = gc
    self.numBodies = bodies
    self.timeSteps = timeSteps
    self.masses = Array(repeating: 0, count: bodies)
    self.positions = defaultState
    self.accelerations = defaultState
    self.velocities = defaultState

    let bodyData = lines.dropFirst().map({ $0.compactMap(Double.init) })

    guard bodyData.count == bodies * 3 else {
      return nil
    }

    for n in 0..<bodies {
      masses[n] = bodyData[0 + n * 3][0]

      guard let position = Vector(array: bodyData[1 + n * 3]),
            let velocity = Vector(array: bodyData[2 + n * 3]) else {
        return nil
      }

      positions[n] = position
      velocities[n] = velocity
    }
  }

  private func computeAccelerations() {
    for i in 0..<numBodies {
      accelerations[i] = .origin

      for j in 0..<numBodies where i != j {
        let t = gravitationalConstant * masses[j] / pow((positions[i] - positions[j]).mod(), 3)
        accelerations[i] = accelerations[i] + (positions[j] - positions[i]) * t
      }
    }
  }

  private func resolveCollisions() {
    for i in 0..<numBodies {
      for j in 0..<numBodies where positions[i] == positions[j] {
        velocities.swapAt(i, j)
      }
    }
  }

  private func computeVelocities() {
    for i in 0..<numBodies {
      velocities[i] = velocities[i] + accelerations[i]
    }
  }

  private func computePositions() {
    for i in 0..<numBodies {
      positions[i] = positions[i] + velocities[i] + accelerations[i] * 0.5
    }
  }

  public func printState() {
    for i in 0..<numBodies {
      print("Body \(i + 1): \(positions[i])  |  \(velocities[i])")
    }
  }

  public func simulate() {
    computeAccelerations()
    computePositions()
    computeVelocities()
    resolveCollisions()
  }
}

guard let sim = NBody(file: "input.txt") else {
  fatalError()
}

print()
print("Body   :      x          y          z    |     vx         vy         vz")

for i in 0..<sim.timeSteps {
  print("Step \(i + 1)")
  sim.simulate()
  sim.printState()
  print()
}
