import Foundation
import Numerics
import QDBMP

public typealias Color = (red: UInt8, green: UInt8, blue: UInt8)

public class BitmapDrawer {
  public let imageHeight: Int
  public let imageWidth: Int

  var grid: [[Color?]]

  private let bmp: OpaquePointer

  public init(height: Int, width: Int) {
    self.imageHeight = height
    self.imageWidth = width
    self.grid = [[Color?]](repeating: [Color?](repeating: nil, count: height), count: width)
    self.bmp = BMP_Create(UInt(width), UInt(height), 24)

    checkError()
  }

  deinit {
    BMP_Free(bmp)
  }

  private func checkError() {
    let err = BMP_GetError()

    guard err == BMP_STATUS(0) else {
      fatalError("\(err)")
    }
  }

  public func save(to path: String = "~/Desktop/out.bmp") {
    for x in 0..<imageWidth {
      for y in 0..<imageHeight {
        guard let color = grid[x][y] else { continue }

        BMP_SetPixelRGB(bmp, UInt(x), UInt(y), color.red, color.green, color.blue)
        checkError()
      }
    }

    (path as NSString).expandingTildeInPath.withCString {s in
      BMP_WriteFile(bmp, s)
    }
  }

  public func setPixel(x: Int, y: Int, to color: Color?) {
    grid[x][y] = color
  }
}

let imageSize = 10_000
let canvas = BitmapDrawer(height: imageSize, width: imageSize)
let maxIterations = 256
let cxMin = -2.0
let cxMax = 1.0
let cyMin = -1.5
let cyMax = 1.5
let scaleX = (cxMax - cxMin) / Double(imageSize)
let scaleY = (cyMax - cyMin) / Double(imageSize)

for x in 0..<imageSize {
  for y in 0..<imageSize {
    let cx = cxMin + Double(x) * scaleX
    let cy = cyMin + Double(y) * scaleY

    let c = Complex(cx, cy)
    var z = Complex(0.0, 0.0)
    var i = 0

    for t in 0..<maxIterations {
      if z.magnitude > 2 {
        break
      }

      z = z * z + c
      i = t
    }

    canvas.setPixel(x: x, y: y, to: Color(red: UInt8(i), green: UInt8(i), blue: UInt8(i)))
  }
}

canvas.save()
