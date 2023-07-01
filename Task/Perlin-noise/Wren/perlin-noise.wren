var permutation = [
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

var p = (0...512).map { |i| (i < 256) ? permutation[i] : permutation[i-256] }.toList

var fade = Fn.new { |t| t * t * t * (t * (t * 6 - 15) + 10) }

var lerp = Fn.new { |t, a, b| a + t * (b - a) }

var grad = Fn.new { |hash, x, y, z|
    // Convert low 4 bits of hash code into 12 gradient directions
    var h = hash & 15
    var u = (h < 8) ? x : y
    var v = (h < 4) ? y : (h == 12 || h == 14) ? x : z
    return (((h & 1) == 0) ? u : -u) + (((h & 2) == 0) ? v : -v)
}

var noise = Fn.new { |x, y, z|
    // Find unit cube that contains point
    var xi = x.floor & 255
    var yi = y.floor & 255
    var zi = z.floor & 255

    // Find relative x, y, z of point in cube
    var xx = x.fraction
    var yy = y.fraction
    var zz = z.fraction

    // Compute fade curves for each of xx, yy, zz
    var u = fade.call(xx)
    var v = fade.call(yy)
    var w = fade.call(zz)

    // Hash co-ordinates of the 8 cube corners
    // and add blended results from 8 corners of cube
    var a  = p[xi] + yi
    var aa = p[a] + zi
    var ab = p[a + 1] + zi
    var b  = p[xi + 1] + yi
    var ba = p[b] + zi
    var bb = p[b + 1] + zi

    return lerp.call(w,
        lerp.call(v, lerp.call(u, grad.call(p[aa], xx, yy, zz), grad.call(p[ba], xx - 1, yy, zz)),
        lerp.call(u, grad.call(p[ab], xx, yy - 1, zz), grad.call(p[bb], xx - 1, yy - 1, zz))),
        lerp.call(v, lerp.call(u, grad.call(p[aa + 1], xx, yy, zz - 1), grad.call(p[ba + 1], xx - 1, yy, zz - 1)),
        lerp.call(u, grad.call(p[ab + 1], xx, yy - 1, zz - 1), grad.call(p[bb + 1], xx - 1, yy - 1, zz - 1)))
    )
}

System.print(noise.call(3.14, 42, 7))
