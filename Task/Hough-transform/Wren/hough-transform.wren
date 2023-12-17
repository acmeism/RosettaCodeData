import "graphics" for Canvas, Color, ImageData
import "dome" for Window, Process
import "math" for Math

var Hypot = Fn.new { |x, y| (x*x + y*y).sqrt }

class ArrayData {
    construct new(width, height) {
        _width  = width
        _height = height
        _dataArray = List.filled(width * height, 0)
    }

    width  { _width }
    height { _height }

    [x, y] { _dataArray[y * _width + x] }

    [x, y]=(v) { _dataArray[y * _width + x] = v }

    transform(thetaAxisSize, rAxisSize, minContrast) {
        var maxRadius = Math.ceil(Hypot.call(_width, _height))
        var halfRAxisSize = rAxisSize >> 1
        var outputData = ArrayData.new(thetaAxisSize, rAxisSize)
        // x output ranges from 0 to pi
        // y output ranges from -maxRadius to maxRadius
        var sinTable = List.filled(thetaAxisSize, 0)
        var cosTable = List.filled(thetaAxisSize, 0)
        for (theta in thetaAxisSize - 1..0) {
            var thetaRadians = theta * Num.pi / thetaAxisSize
            sinTable[theta] = Math.sin(thetaRadians)
            cosTable[theta] = Math.cos(thetaRadians)
        }
        for (y in _height - 1..0) {
            for (x in _width - 1..0) {
                if (contrast(x, y, minContrast)) {
                    for (theta in thetaAxisSize - 1..0) {
                        var r = cosTable[theta] * x + sinTable[theta] * y
                        var rScaled = Math.round(r * halfRAxisSize / maxRadius) + halfRAxisSize
                        outputData.accumulate(theta, rScaled, 1)
                    }
                }
            }
        }
        return outputData
    }

    accumulate(x, y, delta) { this[x, y] = this[x, y] + delta }

    contrast(x, y, minContrast) {
        var centerValue = this[x, y]
        for (i in 8..0) {
            if (i != 4) {
                var newx = x + i % 3 - 1
                var newy = y + (i / 3).truncate - 1
                if (newx >= 0 && newx < width && newy >= 0 && newy < height &&
                    Math.abs(this[newx, newy] - centerValue) >= minContrast) return true
            }
        }
        return false
    }

    max {
        var max = _dataArray[0]
        for (i in width * height - 1..1) {
            if (_dataArray[i] > max) max = _dataArray[i]
        }
        return max
    }
}

class HoughTransform {
    construct new(inFile, outFile, width, height, minCont) {
        Window.title = "Hough Transform"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _width   = width
        _height  = height
        _inFile  = inFile
        _outFile = outFile
        _minCont = minCont
    }

    init() {
        var dataArray = readInputFromImage(_inFile)
        dataArray = dataArray.transform(_width, _height, _minCont)
        writeOutputImage(_outFile, dataArray)
    }

    readInputFromImage(filename) {
        var inputImage = ImageData.load(filename)
        var width  = inputImage.width
        var height = inputImage.height
        var rgbData = []
        for (y in 0...height) {
            for (x in 0...width) rgbData.add(inputImage.pget(x, y))
        }
        var arrayData = ArrayData.new(width, height)
        // Flip y axis when reading image
        for (y in 0...height) {
            for (x in 0...width) {
                var rgbValue = rgbData[y * width + x]
                rgbValue = (rgbValue.r * 0.3 + rgbValue.g * 0.59 + rgbValue.b * 0.11).floor
                arrayData[x, height - 1 - y] = rgbValue
            }
        }
        return arrayData
    }

    writeOutputImage(filename, arrayData) {
        var max = arrayData.max
        var outputImage = ImageData.create(filename, arrayData.width, arrayData.height)
        for (y in 0...arrayData.height) {
            for (x in 0...arrayData.width) {
                var n = Math.min(Math.round(arrayData[x, y] * 255 / max), 255)
                var c = Color.new(n, n, 0x90)
                outputImage.pset(x, arrayData.height - 1 - y, c)
             }
        }
        outputImage.draw(0, 0)
        outputImage.saveToFile(filename)
    }

    update() {}

    draw(alpha) {}
}

var args = Process.args
System.print(args)
if (args.count != 7) Fiber.abort("There should be exactly 5 command line arguments.")
var inFile  = args[2]
var outFile = args[3]
var width   = Num.fromString(args[4])
var height  = Num.fromString(args[5])
var minCont = Num.fromString(args[6])
var Game = HoughTransform.new(inFile, outFile, width, height, minCont)
