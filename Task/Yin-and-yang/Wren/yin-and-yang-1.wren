var inCircle = Fn.new { |centerX, centerY, radius, x, y|
    return (x-centerX)*(x-centerX)+(y-centerY)*(y-centerY) <= radius*radius
}

var inBigCircle        = Fn.new { |radius, x, y| inCircle.call(0, 0, radius, x, y) }

var inBlackSemiCircle  = Fn.new { |radius, x, y|  inCircle.call(0, -radius/2, radius/2, x, y) }

var inWhiteSemiCircle  = Fn.new { |radius, x, y|  inCircle.call(0,  radius/2, radius/2, x, y) }

var inSmallBlackCircle = Fn.new { |radius, x, y| inCircle.call(0,  radius/2, radius/6, x, y) }

var inSmallWhiteCircle = Fn.new { |radius, x, y| inCircle.call(0, -radius/2, radius/6, x, y) }

var yinAndYang = Fn.new { |radius|
    var black = "#"
    var white = "."
    var scaleX = 2
    var scaleY = 1
    for (sy in radius*scaleY..-(radius*scaleY)) {
        for (sx in -(radius*scaleX)..(radius*scaleX)) {
            var x = sx / scaleX
            var y = sy / scaleY
            if (inBigCircle.call(radius, x, y)) {
                if (inWhiteSemiCircle.call(radius, x, y)) {
                    System.write(inSmallBlackCircle.call(radius, x, y) ? black : white)
                } else if (inBlackSemiCircle.call(radius, x, y)) {
                    System.write(inSmallWhiteCircle.call(radius, x, y) ? white : black)
                } else {
                    System.write((x < 0) ? white : black)
                }
            } else {
                System.write(" ")
            }
        }
        System.print()
    }
}

yinAndYang.call(16)
yinAndYang.call(8)
