import Foundation

struct Perlin {
  private static let permutation = [
    151, 160, 137,  91,  90,  15, 131,  13, 201,  95,  96,  53, 194, 233,   7, 225,
    140,  36, 103,  30,  69, 142,   8,  99,  37, 240,  21,  10,  23, 190,   6, 148,
    247, 120, 234,  75,   0,  26, 197,  62,  94, 252, 219, 203, 117,  35,  11,  32,
    57, 177,  33,  88, 237, 149,  56,  87, 174,  20, 125, 136, 171, 168,  68, 175,
    74, 165,  71, 134, 139,  48,  27, 166,  77, 146, 158, 231,  83, 111, 229, 122,
    60, 211, 133, 230, 220, 105,  92,  41,  55,  46, 245,  40, 244, 102, 143,  54,
    65,  25,  63, 161,   1, 216,  80,  73, 209,  76, 132, 187, 208,  89,  18, 169,
    200, 196, 135, 130, 116, 188, 159,  86, 164, 100, 109, 198, 173, 186,   3,  64,
    52, 217, 226, 250, 124, 123,   5, 202,  38, 147, 118, 126, 255,  82,  85, 212,
    207, 206,  59, 227,  47,  16,  58,  17, 182, 189,  28,  42, 223, 183, 170, 213,
    119, 248, 152,   2,  44, 154, 163,  70, 221, 153, 101, 155, 167,  43, 172,   9,
    129,  22,  39, 253,  19,  98, 108, 110,  79, 113, 224, 232, 178, 185, 112, 104,
    218, 246,  97, 228, 251,  34, 242, 193, 238, 210, 144,  12, 191, 179, 162, 241,
    81,  51, 145, 235, 249,  14, 239, 107,  49, 192, 214,  31, 181, 199, 106, 157,
    184,  84, 204, 176, 115, 121,  50,  45, 127,   4, 150, 254, 138, 236, 205,  93,
    222, 114,  67,  29,  24,  72, 243, 141, 128, 195,  78,  66, 215,  61, 156, 180
  ]

  private static let p = (0..<512).map({i -> Int in
    if i < 256 {
      return permutation[i]
    } else {
      return permutation[i - 256]
    }
  })

  private static func fade(_ t: Double) -> Double { t * t * t * (t * (t * 6 - 15) + 10) }

  private static func lerp(_ t: Double, _ a: Double, _ b: Double) -> Double { a + t * (b - a) }

  private static func grad(_ hash: Int, _ x: Double, _ y: Double, _ z: Double) -> Double {
    let h = hash & 15
    let u = h < 8 ? x : y
    let v = h < 4 ? y : h == 12 || h == 14 ? x : z

    return (h & 1 == 0 ? u : -u) + (h & 2 == 0 ? v : -v)
  }

  static func noise(x: Double, y: Double, z: Double) -> Double {
    let xi = Int(x) & 255
    let yi = Int(y) & 255
    let zi = Int(z) & 255

    let xx = x - floor(x)
    let yy = y - floor(y)
    let zz = z - floor(z)

    let u = fade(xx)
    let v = fade(yy)
    let w = fade(zz)

    let a  = p[xi] + yi
    let aa = p[a] + zi
    let b  = p[xi + 1] + yi
    let ba = p[b] + zi
    let ab = p[a + 1] + zi
    let bb = p[b + 1] + zi

    return lerp(w, lerp(v, lerp(u, grad(p[aa], xx, yy, zz),
      grad(p[ba], xx - 1, yy, zz)),
      lerp(u, grad(p[ab], xx, yy - 1, zz),
        grad(p[bb], xx - 1, yy - 1, zz))),
      lerp(v, lerp(u, grad(p[aa + 1], xx, yy, zz - 1),
        grad(p[ba + 1], xx - 1, yy, zz - 1)),
        lerp(u, grad(p[ab + 1], xx, yy - 1, zz - 1),
          grad(p[bb + 1], xx - 1, yy - 1, zz - 1))))
  }
}

print(Perlin.noise(x: 3.14, y: 42, z: 7))
