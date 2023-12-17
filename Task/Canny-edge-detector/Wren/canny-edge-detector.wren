import "dome" for Window
import "graphics" for Canvas, Color, ImageData
import "math" for Math
import "./check" for Check

var MaxBrightness = 255

class Canny {
    construct new(inFile, outFile) {
        Window.title = "Canny edge detection"
        var image1 = ImageData.load(inFile)
        var w = image1.width
        var h = image1.height
        Window.resize(w * 2 + 20, h)
        Canvas.resize(w * 2 + 20, h)
        var image2 = ImageData.create(outFile, w, h)
        var pixels = List.filled(w * h, 0)
        var ix = 0
        // convert image1 to gray scale as a list of pixels
        for (y in 0...h) {
            for (x in 0...w) {
                var c1 = image1.pget(x, y)
                var lumin = (0.2126 * c1.r + 0.7152 * c1.g + 0.0722 * c1.b).floor
                pixels[ix] = lumin
                ix = ix + 1
            }
        }

        // find edges
        var data = cannyEdgeDetection(pixels, w, h, 45, 50, 1)

        // write to image2
        ix = 0
        for (y in 0...h) {
            for (x in 0...w) {
                var d = data[ix]
                var c = Color.rgb(d, d, d)
                image2.pset(x, y, c)
                ix = ix + 1
            }
        }

        // display the two images side by side
        image1.draw(0, 0)
        image2.draw(w + 20, 0)

        // save image2 to outFile
        image2.saveToFile(outFile)
    }

    init() {}

    // If normalize is true, map pixels to range 0..MaxBrightness
    convolution(input, output, kernel, nx, ny, kn, normalize) {
        Check.ok((kn % 2) == 1)
        Check.ok(nx > kn && ny > kn)
        var khalf = (kn / 2).floor
        var min = Num.largest
        var max = -min
        if (normalize) {
            for (m in khalf...nx-khalf) {
                for (n in khalf...ny-khalf) {
                    var pixel = 0
                    var c = 0
                    for (j in -khalf..khalf) {
                        for (i in -khalf..khalf) {
                            pixel = pixel + input[(n-j)*nx + m - i] * kernel[c]
                            c = c + 1
                        }
                    }
                    if (pixel < min) min = pixel
                    if (pixel > max) max = pixel
                }
            }
        }

        for (m in khalf...nx-khalf) {
            for (n in khalf...ny-khalf) {
                var pixel = 0
                var c = 0
                for (j in -khalf..khalf) {
                    for (i in -khalf..khalf) {
                        pixel = pixel + input[(n-j)*nx + m - i] * kernel[c]
                        c = c + 1
                    }
                }
                if (normalize) pixel = MaxBrightness * (pixel - min) / (max - min)
                output[n * nx + m] = pixel.truncate
            }
        }
    }

    gaussianFilter(input, output, nx, ny, sigma) {
        var n = 2 * (2 * sigma).truncate + 3
        var mean = (n / 2).floor
        var kernel = List.filled(n * n, 0)
        System.print("Gaussian filter: kernel size = %(n), sigma = %(sigma)")
        var c = 0
        for (i in 0...n) {
            for (j in 0...n) {
                var t = (-0.5 * (((i - mean) / sigma).pow(2) + ((j - mean) / sigma).pow(2))).exp
                kernel[c] = t / (2 * Num.pi * sigma * sigma)
                c = c + 1
            }
        }
        convolution(input, output, kernel, nx, ny, n, true)
    }

    // Returns the square root of 'x' squared + 'y' squared.
    hypot(x, y) { (x*x + y*y).sqrt }

    cannyEdgeDetection(input, nx, ny, tmin, tmax, sigma) {
        var output = List.filled(input.count, 0)
        gaussianFilter(input, output, nx, ny, sigma)
        var Gx = [-1, 0, 1, -2, 0, 2, -1, 0, 1]
        var afterGx = List.filled(input.count, 0)
        convolution(output, afterGx, Gx, nx, ny, 3, false)
        var Gy = [1, 2, 1, 0, 0, 0, -1, -2, -1]
        var afterGy = List.filled(input.count, 0)
        convolution(output, afterGy, Gy, nx, ny, 3, false)
        var G = List.filled(input.count, 0)
        for (i in 1..nx-2) {
            for (j in 1..ny-2) {
                var c = i + nx * j
                G[c] = hypot(afterGx[c], afterGy[c]).floor
            }
        }

        // non-maximum suppression: straightforward implementation
        var nms = List.filled(input.count, 0)
        for (i in 1..nx-2) {
            for (j in 1..ny-2) {
                var c = i + nx * j
                var nn = c - nx
                var ss = c + nx
                var ww = c + 1
                var ee = c - 1
                var nw = nn + 1
                var ne = nn - 1
                var sw = ss + 1
                var se = ss - 1
                var temp = Math.atan(afterGy[c], afterGx[c]) + Num.pi
                var dir = (temp % Num.pi) / Num.pi * 8
                if (((dir <= 1 || dir > 7) && G[c] > G[ee] && G[c] > G[ww]) ||   // O°
                    ((dir > 1 && dir <= 3) && G[c] > G[nw] && G[c] > G[se]) ||   // 45°
                    ((dir > 3 && dir <= 5) && G[c] > G[nn] && G[c] > G[ss]) ||   // 90°
                    ((dir > 5 && dir <= 7) && G[c] > G[ne] && G[c] > G[sw])) {   // 135°
                    nms[c] = G[c]
                } else {
                    nms[c] = 0
                }
            }
        }

        // tracing edges with hysteresis: non-recursive implementation
        var edges = List.filled((input.count/2).floor, 0)
        for (i in 0...output.count) output[i] = 0
        var c = 1
        for (j in 1..ny-2) {
            for (i in 1..nx-2) {
                if (nms[c] >= tmax && output[c] == 0) {
                    // trace edges
                    output[c] = MaxBrightness
                    var nedges = 1
                    edges[0] = c
                    while (true) {
                        nedges = nedges - 1
                        var t = edges[nedges]
                        var nbs = [     // neighbors
                           t - nx,      // nn
                           t + nx,      // ss
                           t + 1,       // ww
                           t - 1,       // ee
                           t - nx + 1,  // nw
                           t - nx - 1,  // ne
                           t + nx + 1,  // sw
                           t + nx - 1   // se
                        ]
                        for (n in nbs) {
                            if (nms[n] >= tmin && output[n] == 0) {
                                output[n] = MaxBrightness
                                edges[nedges] = n
                                nedges = nedges + 1
                            }
                        }
                        if (nedges == 0) break
                    }
                }
                c = c + 1
            }
        }
        return output
    }

    update() {}

    draw(alpha) {}
}
var Game = Canny.new("Valve_original.png", "Valve_monchrome_canny.png")
