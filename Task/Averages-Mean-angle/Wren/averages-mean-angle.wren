import "/fmt" for Fmt

var meanAngle = Fn.new { |angles|
    var n = angles.count
    var sinSum = 0
    var cosSum = 0
    for (angle in angles) {
        sinSum = sinSum + (angle * Num.pi / 180).sin
        cosSum = cosSum + (angle * Num.pi / 180).cos
    }
    return (sinSum/n).atan(cosSum/n) * 180 / Num.pi
}

var angles1 = [350, 10]
var angles2 = [90, 180, 270, 360]
var angles3 = [10, 20, 30]

var i = 1
for (angles in [angles1, angles2, angles3]) {
    System.print("Mean for angles %(i) is : %(Fmt.f(6, meanAngle.call(angles), 2))")
    i = i + 1
}
