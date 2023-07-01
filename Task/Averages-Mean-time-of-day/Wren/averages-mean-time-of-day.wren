import "/fmt" for Fmt

var timeToDegs = Fn.new { |time|
    var t = time.split(":")
    var h = Num.fromString(t[0]) * 3600
    var m = Num.fromString(t[1]) * 60
    var s = Num.fromString(t[2])
    return (h + m + s) / 240
}

var degsToTime = Fn.new { |d|
    while (d < 0) d = d + 360
    var s = (d * 240).round
    var h = (s/3600).floor
    var m = s % 3600
    s = m % 60
    m = (m / 60).floor
    return "%(Fmt.d(2, h)):%(Fmt.d(2, m)):%(Fmt.d(2, s))"
}

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

var times = ["23:00:17", "23:40:20", "00:12:45", "00:17:19"]
var angles = times.map { |t| timeToDegs.call(t) }.toList
System.print("Mean time of day is : %(degsToTime.call(meanAngle.call(angles)))")
