import "dome" for Window
import "graphics" for Canvas, Color, ImageData
import "./dynamic" for Struct
import "./sort" for Sort

var QItem = Struct.create("QItem", ["color", "index"])

var ColorsUsed = []

class ColorQuantization {
    construct new(filename, filename2) {
        Window.title = "Color quantization"
        _image = ImageData.loadFromFile(filename)
        _w = _image.width
        _h = _image.height
        Window.resize(_w * 2 + 20, _h + 30)
        Canvas.resize(_w * 2 + 20, _h + 30)

        // draw original image on left half of canvas
        _image.draw(0, 0)
        Canvas.print(filename, _w/4, _h + 10, Color.white)

        // create ImageData object for the quantized image
        _qImage = ImageData.create(filename2, _w, _h)
        _qFilename = filename2
    }

    init() {
        // build the first bucket
        var bucket = List.filled(_w * _h, null)
        for (x in 0..._w) {
            for (y in 0..._h) {
                var idx = x * _w + y
                bucket[idx] = QItem.new(_image.pget(x, y), idx)
            }
        }
        var output = List.filled(_w * _h, Color.black)

        // launch the quantization
        medianCut(bucket, 4, output)

        // load the result into the quantized ImageData object
        for (x in 0..._w) {
            for (y in 0..._h) {
                _qImage.pset(x, y, output[x *_w + y])
            }
        }

        // draw the quantized image on right half of canvas
        _qImage.draw(_w + 20, 0)
        Canvas.print(_qFilename, _w * 5/4 + 20, _h + 10, Color.white)

        // save it to a file
        _qImage.saveToFile(_qFilename)

        // print colors used to terminal
        System.print("The 16 colors used in R, G, B format are:")
        for (c in ColorsUsed) {
            System.print("(%(c.r), %(c.g), %(c.b))")
        }
    }

    // apply the quantization to the colors in the bucket
    quantize(bucket, output) {
        // compute the mean value on each RGB component
        var means = List.filled(3, 0)
        for (q in bucket) {
            var i = 0
            for (val in [q.color.r, q.color.g, q.color.b]) {
                means[i] = means[i] + val
                i = i + 1
            }
        }
        for (i in 0..2) {
            means[i] = (means[i]/bucket.count).floor
        }
        var c = Color.rgb(means[0], means[1], means[2])
        ColorsUsed.add(c)

        // store the new color in the output list
        for (q in bucket) output[q.index] = c
    }

    // apply the algorithm to the bucket of colors
    medianCut(bucket, depth, output) {
        if (depth == 0) {  // terminated for this bucket, apply the quantization
            quantize(bucket, output)
            return
        }

        // compute the range of values for each RGB component
        var minVal = [1000, 1000, 1000]
        var maxVal = [-1, -1, -1]
        for (q in bucket) {
            var i = 0
            for (val in [q.color.r, q.color.g, q.color.b]) {
                if (val < minVal[i]) minVal[i] = val
                if (val > maxVal[i]) maxVal[i] = val
                i = i + 1
            }
        }
        var valRange = [maxVal[0] - minVal[0], maxVal[1] - minVal[1], maxVal[2] - minVal[2]]

        // find the RGB component with the greatest range
        var greatest = 0
        if (valRange[1] > valRange[0]) greatest = 1
        if (valRange[2] > greatest) greatest = 2
        // sort the quantization items according to the greatest
        var cmp
        if (greatest == 0) {
            cmp = Fn.new { |i, j|
                var t = (i.color.r - j.color.r).sign
                if (t != 0) return t
                return (i.index - j.index).sign
            }
        } else if (greatest == 1) {
            cmp = Fn.new { |i, j|
                var t = (i.color.g - j.color.g).sign
                if (t != 0) return t
                return (i.index - j.index).sign
            }
        } else {
            cmp = Fn.new { |i, j|
                var t = (i.color.b - j.color.b).sign
                if (t != 0) return t
                return (i.index - j.index).sign
            }
        }
        Sort.quick(bucket, 0, bucket.count-1, cmp)
        var medianIndex = ((bucket.count-1)/2).floor
        medianCut(bucket[0...medianIndex], depth - 1, output)
        medianCut(bucket[medianIndex..-1], depth - 1, output)
    }

    update() {}

    draw(alpha) {}
}

var Game = ColorQuantization.new("Quantum_frog.png", "Quantum_frog_16.png")
