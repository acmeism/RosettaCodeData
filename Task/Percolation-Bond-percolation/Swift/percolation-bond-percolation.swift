let randMax = 32767.0
let filled = 1
let rightWall = 2
let bottomWall = 4

final class Percolate {
  let height: Int
  let width: Int

  private var grid: [Int]
  private var end: Int

  init(height: Int, width: Int) {
    self.height = height
    self.width = width
    self.end = width
    self.grid = [Int](repeating: 0, count: width * (height + 2))
  }

  private func fill(at p: Int) -> Bool {
    guard grid[p] & filled == 0 else { return false }

    grid[p] |= filled

    guard p < end else { return true }

    return (((grid[p + 0] & bottomWall) == 0) && fill(at: p + width)) ||
            (((grid[p + 0] & rightWall) == 0) && fill(at: p + 1)) ||
            (((grid[p - 1] & rightWall) == 0) && fill(at: p - 1)) ||
            (((grid[p - width] & bottomWall) == 0) && fill(at: p - width))
  }

  func makeGrid(porosity p: Double) {
    grid = [Int](repeating: 0, count: width * (height + 2))
    end = width

    let thresh = Int(randMax * p)

    for i in 0..<width {
      grid[i] = bottomWall | rightWall
    }

    for _ in 0..<height {
      for _ in stride(from: width - 1, through: 1, by: -1) {
        let r1 = Int.random(in: 0..<Int(randMax)+1)
        let r2 = Int.random(in: 0..<Int(randMax)+1)

        grid[end] = (r1 < thresh ? bottomWall : 0) | (r2 < thresh ? rightWall : 0)

        end += 1
      }

      let r3 = Int.random(in: 0..<Int(randMax)+1)

      grid[end] = rightWall | (r3 < thresh ? bottomWall : 0)

      end += 1
    }
  }

  @discardableResult
  func percolate() -> Bool {
    var i = 0

    while i < width && !fill(at: width + i) {
      i += 1
    }

    return i < width
  }

  func showGrid() {
    for _ in 0..<width {
      print("+--", terminator: "")
    }

    print("+")

    for i in 0..<height {
      print(i == height ? " " : "|", terminator: "")

      for j in 0..<width {
        print(grid[i * width + j + width] & filled != 0 ? "[]" : "  ", terminator: "")
        print(grid[i * width + j + width] & rightWall != 0 ? "|" : " ", terminator: "")
      }

      print()

      guard i != height else { return }

      for j in 0..<width {
        print(grid[i * width + j + width] & bottomWall != 0 ? "+--" : "+  ", terminator: "")
      }

      print("+")
    }
  }
}

let p = Percolate(height: 10, width: 10)

p.makeGrid(porosity: 0.5)
p.percolate()
p.showGrid()

print("Running \(p.height) x \(p.width) grid 10,000 times for each porosity")

for factor in 1...10 {
  var count = 0
  let porosity = Double(factor) / 10.0

  for _ in 0..<10_000 {
    p.makeGrid(porosity: porosity)

    if p.percolate() {
      count += 1
    }
  }

  print("p = \(porosity): \(Double(count) / 10_000.0)")
}
