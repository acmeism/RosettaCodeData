import "graphics" for Canvas, Color, ImageData
import "dome" for Window

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
}

class ImageConvolution {
    construct new(width, height, image1, image2, kernel, divisor) {
        Window.title = "Image Convolution"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _width  = width
        _height = height
        _image1 = image1
        _image2 = image2
        _kernel = kernel
        _divisor = divisor
    }

    init() {
        var dataArrays = getArrayDatasFromImage(_image1)
        for (i in 0...dataArrays.count) {
            dataArrays[i] = convolve(dataArrays[i], _kernel, _divisor)
        }
        writeOutputImage(_image2, dataArrays)
    }

    bound(value, endIndex) {
        if (value < 0) return 0
        if (value < endIndex) return value
        return endIndex - 1
    }

    convolve(inputData, kernel, kernelDivisor) {
        var inputWidth   = inputData.width
        var inputHeight  = inputData.height
        var kernelWidth  = kernel.width
        var kernelHeight = kernel.height
        if (kernelWidth <= 0 || (kernelWidth & 1) != 1) {
            Fiber.abort("Kernel must have odd width")
        }
        if (kernelHeight <= 0 || (kernelHeight & 1) != 1) {
            Fiber.abort("Kernel must have odd height")
        }
        var kernelWidthRadius  = kernelWidth >> 1
        var kernelHeightRadius = kernelHeight >> 1

        var outputData = ArrayData.new(inputWidth, inputHeight)
        for (i in inputWidth - 1..0) {
            for (j in inputHeight - 1..0) {
                var newValue = 0
                for (kw in kernelWidth - 1..0) {
                    for (kh in kernelHeight - 1..0) {
                        newValue = newValue + kernel[kw, kh] * inputData[
                            bound(i + kw - kernelWidthRadius, inputWidth),
                            bound(j + kh - kernelHeightRadius, inputHeight)
                        ]
                        outputData[i, j] = (newValue / kernelDivisor).round
                    }
                }
            }
        }
        return outputData
    }

    getArrayDatasFromImage(filename) {
        var inputImage = ImageData.load(filename)
        inputImage.draw(0, 0)
        Canvas.print(filename, _width * 1/6,  _height * 5/6, Color.white)
        var width  = inputImage.width
        var height = inputImage.height
        var rgbData = []
        for (y in 0...height) {
            for (x in 0...width) rgbData.add(inputImage.pget(x, y))
        }
        var reds   = ArrayData.new(width, height)
        var greens = ArrayData.new(width, height)
        var blues  = ArrayData.new(width, height)
        for (y in 0...height) {
            for (x in 0...width) {
                var rgbValue = rgbData[y * width + x]
                reds[x, y]   = rgbValue.r
                greens[x,y]  = rgbValue.g
                blues[x, y]  = rgbValue.b
            }
        }
        return [reds, greens, blues]
    }

    writeOutputImage(filename, redGreenBlue) {
        var reds   = redGreenBlue[0]
        var greens = redGreenBlue[1]
        var blues  = redGreenBlue[2]
        var outputImage = ImageData.create(filename, reds.width, reds.height)
        for (y in 0...reds.height) {
            for (x in 0...reds.width) {
                var red   = bound(reds[x, y], 256)
                var green = bound(greens[x, y], 256)
                var blue  = bound(blues[x, y], 256)
                var c = Color.new(red, green, blue)
                outputImage.pset(x, y, c)
             }
        }
        outputImage.draw(_width/2, 0)
        Canvas.print(filename, _width * 2/3,  _height * 5/6, Color.white)
        outputImage.saveToFile(filename)
    }

    update() {}

    draw(alpha) {}
}

var k = [
    [1,  4,  7,  4, 1],
    [4, 16, 26, 16, 4],
    [7, 26, 41, 26, 7],
    [4, 16, 26, 16, 4],
    [1,  4, 7,   4, 1]
]

var divisor = 273

var image1 = "Pentagon.png"
var image2 = "Pentagon2.png"

System.print("Input file %(image1), output file %(image2).")
System.print("Kernel size: %(k.count) x %(k[0].count), divisor %(divisor)")
System.print(k.join("\n"))

var kernel = ArrayData.new(k.count, k[0].count)
for (y in 0...k[0].count) {
    for (x in 0...k.count) kernel[x, y] = k[x][y]
}
var Game = ImageConvolution.new(700, 300, image1, image2, kernel, divisor)
