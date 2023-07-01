import UIKit
import CoreImage
import PlaygroundSupport

let imageWH = 300
let context = CGContext(data: nil,
                        width: imageWH,
                        height: imageWH,
                        bitsPerComponent: 8,
                        bytesPerRow: 0,
                        space: CGColorSpace(name: CGColorSpace.sRGB)!,
                        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!
var x0 = 0.0
var x1 = 0.0
var y0 = 0.0
var y1 = 0.0

context.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
context.fill(CGRect(x: 0, y: 0, width: imageWH, height: imageWH))
context.setFillColor(#colorLiteral(red: 0.539716677, green: 1, blue: 0.265400682, alpha: 1))

for _ in 0..<100_000 {
    switch Int(arc4random()) % 100 {
    case 0:
        x1 = 0
        y1 = 0.16 * y0
    case 1...7:
        x1 = -0.15 * x0 + 0.28 * y0
        y1 = 0.26 * x0 + 0.24 * y0 + 0.44
    case 8...15:
        x1 = 0.2 * x0 - 0.26 * y0
        y1 = 0.23 * x0 + 0.22 * y0 + 1.6
    default:
        x1 = 0.85 * x0 + 0.04 * y0
        y1 = -0.04 * x0 + 0.85 * y0 + 1.6
    }

    context.fill(CGRect(x: 30 * x1 + Double(imageWH) / 2.0, y: 30 * y1,
                        width: 1, height: 1))

    (x0, y0) = (x1, y1)
}

let uiImage = UIImage(cgImage: context.makeImage()!)
