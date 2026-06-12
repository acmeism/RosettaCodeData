import "./ordered" for OrderedMap

var nktg = Fn.new { |x, v, m, dmDt|
    var p = m * v
    var nktg1 = x * p
    var nktg2 = dmDt * p
    var tendency1
    var tendency2

    if (nktg1 > 0) {
        tendency1 = "Moving away from stable state"
    } else if (nktg1 < 0) {
        tendency1 = "Moving toward stable state"
    } else {
        tendency1 = "Stable equilibrium"
    }

    if (nktg2 > 0) {
        tendency2 = "Mass variation supports movement"
    } else if (nktg2 < 0) {
        tendency2 = "Mass variation resists movement"
    } else {
        tendency2 = "No mass variation effect"
    }

    return OrderedMap.create(
        ["p", "NKTg1", "NKTg2", "Tendency1", "Tendency2"],
        [p, nktg1, nktg2, tendency1, tendency2]
    )
}

var result = nktg.call(2, 3, 4, -0.5)
System.print(result)
